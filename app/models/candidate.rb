# == Schema Information
#
# Table name: candidates
#
#  id                                   :bigint(8)        not null, primary key
#  number                               :string
#  first_name                           :string
#  last_name                            :string
#  baccalaureat_id                      :bigint(8)
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  dossier_note                         :float            default(0.0)
#  evaluation_note                      :float            default(0.0)
#  evaluation_comment                   :text             default("")
#  evaluated_by_id                      :bigint(8)
#  level                                :text
#  attitude_id                          :bigint(8)
#  intention_id                         :bigint(8)
#  production_id                        :bigint(8)
#  localization_id                      :bigint(8)
#  position                             :integer
#  parcoursup_entete                    :text
#  parcoursup_scolarite                 :text
#  parcoursup_activites_centres_interet :text
#  parcoursup_bac                       :text
#  parcoursup_bulletins                 :text
#  parcoursup_ael                       :text
#  parcoursup_lettre_motivation         :text
#  parcoursup_groupe                    :text
#  parcoursup_documents                 :text
#  parcoursup_formulaire                :text
#  scholarship                          :boolean          default(FALSE)
#  production_in_formulaire             :boolean          default(FALSE)
#  production_somewhere_else            :boolean          default(FALSE)
#  production_analyzed                  :boolean          default(FALSE)
#  attributed_to_id                     :bigint(8)
#  evaluation_done                      :boolean          default(FALSE)
#  interview_done                       :boolean          default(FALSE)
#  interview_comment                    :text
#  interview_position                   :integer
#  interview_note                       :float
#  interview_knowledge_id               :integer
#  interview_project_id                 :integer
#  interview_motivation_id              :integer
#  interview_culture_id                 :integer
#  interview_argument_id                :integer
#  interview_bonus                      :boolean          default(FALSE)
#  selection_note                       :float
#  selection_position                   :integer
#  evaluation_decile                    :integer
#  interview_decile                     :integer
#  selection_decile                     :integer
#  evaluation_selected                  :boolean          default(FALSE)
#  interview_selected                   :boolean          default(FALSE)
#  selection_selected                   :boolean          default(FALSE)
#

class Candidate < ApplicationRecord

  DECILE_DELTA_THRESHOLD = 3

  belongs_to :baccalaureat

  belongs_to :evaluated_by, class_name: 'User', optional: true
  belongs_to :attributed_to, class_name: 'User', optional: true

  belongs_to :attitude, class_name: 'Modifier', optional: true
  belongs_to :intention, class_name: 'Modifier', optional: true
  belongs_to :production, class_name: 'Modifier', optional: true
  belongs_to :localization, class_name: 'Modifier', optional: true

  belongs_to :interview_knowledge, class_name: 'Modifier', optional: true
  belongs_to :interview_project, class_name: 'Modifier', optional: true
  belongs_to :interview_motivation, class_name: 'Modifier', optional: true
  belongs_to :interview_culture, class_name: 'Modifier', optional: true
  belongs_to :interview_argument, class_name: 'Modifier', optional: true

  has_and_belongs_to_many :interviewers, class_name: 'User'

  scope :search, -> (term) {
    where('unaccent(first_name) ILIKE unaccent(?)
          OR unaccent(last_name) ILIKE unaccent(?)
          OR number ILIKE ?',
      "%#{term}%",
      "%#{term}%",
      "%#{term}%")
  }
  scope :ordered_by_date, -> { order(updated_at: :desc) }
  scope :ordered_by_evaluation, -> { order(evaluation_note: :desc) }
  scope :ordered_by_interview, -> { order(interview_note: :desc, evaluation_note: :desc) }
  scope :ordered_by_selection, -> { order(selection_note: :desc, interview_note: :desc, evaluation_note: :desc) }

  scope :parcoursup_synced, -> { where.not(parcoursup_formulaire: nil)}

  scope :evaluation_todo, -> { where(evaluation_done: false)}
  scope :evaluation_done, -> { where(evaluation_done: true)}
  scope :evaluation_selected, -> { where(evaluation_selected: true) }

  scope :interview_todo, -> { where(interview_done: false)}
  scope :interview_done, -> { where(interview_done: true)}
  scope :interview_selected, -> { where(interview_selected: true) }

  scope :selection_selected, -> { where(selection_selected: true) }

  before_save :denormalize_notes

  validates_length_of :evaluation_comment, minimum: 15, allow_blank: false, on: :evaluation
  validates_presence_of :attitude, on: :evaluation
  validates_presence_of :intention, on: :evaluation
  validates_presence_of :production, on: :evaluation
  validates_presence_of :localization, on: :evaluation

  validates_presence_of :interview_knowledge, on: :interview
  validates_presence_of :interview_project, on: :interview
  validates_presence_of :interview_motivation, on: :interview
  validates_presence_of :interview_culture, on: :interview
  validates_presence_of :interview_argument, on: :interview
  validates_presence_of :interview_comment, on: :interview
  validates_presence_of :interviewers, on: :interview

  def self.import(csv)
    require 'csv'
    rows = CSV.parse csv, {
      headers: :first_row,
      col_sep: ';'
    }
    rows.each do |row|
      title = row[6]
      baccalaureat = Baccalaureat.with_title_and_parent(title, nil)
      title = row[13]
      unless title.blank?
        baccalaureat = Baccalaureat.with_title_and_parent(title, baccalaureat)
        title = row[15]
        unless title.blank?
          baccalaureat = Baccalaureat.with_title_and_parent(title, baccalaureat)
        end
      end

      number = "#{row[3]}"
      validated = row[17].to_s == 'Oui'
      if validated
        first_name = "#{row[5]}"
        last_name = "#{row[4]}"
        level = "#{row[10]} - #{row[11]}"
        scholarship = row[8].to_s == 'Oui'
        candidate = Candidate.where(number: number).first_or_create
        candidate.first_name = first_name
        candidate.last_name = last_name
        candidate.baccalaureat = baccalaureat
        candidate.level = level
        candidate.scholarship = scholarship
        candidate.dossier_note = Note.average(row)
        candidate.save
        puts "Created candidate #{number}"
      else
        Candidate.where(number: number).destroy_all
        puts "Deleted candidate #{number}"
      end
    end
  end

  def self.positionize
    set_positions_in_list_by_key(ordered_by_evaluation, :evaluation_note, :position)
    set_positions_in_list_by_key(ordered_by_interview, :interview_note, :interview_position)
    set_positions_in_list_by_key(ordered_by_selection, :interview_note, :selection_position)
    set_deciles(ordered_by_evaluation, :evaluation_decile)
    set_deciles(evaluation_selected.ordered_by_evaluation, :interview_decile)
    set_deciles(interview_selected.ordered_by_interview, :selection_decile)
    # Selections
    find_each do |candidate|
      evaluation_selected = candidate.position < Setting.first.interview_number_of_candidates
      candidate.update_column :evaluation_selected, evaluation_selected
    end
    ordered_by_interview.each_with_index do |candidate, index|
      interview_selected = candidate.evaluation_selected && index < Setting.first.selection_number_of_candidates
      selection_selected = interview_selected
      candidate.update_columns  interview_selected: interview_selected,
                                selection_selected: selection_selected
    end
  end

  def self.recompute_notes
    find_each &:save
    positionize
  end

  def parcoursup_synced?
    !parcoursup_formulaire.blank?
  end

  def parcoursup_sync!
    Parcoursup::PARTS.each do |part|
      key = parcoursup_part_to_key(part)
      value = self.send key
      if value.blank?
        value = Parcoursup.instance.load_page(number, part)
        update_column key, value
        sleep 1
      end
    end
  end

  def find_production!
    return unless parcoursup_synced?
    # Formulaire
    formulaire = parcoursup_clean('formulaire')
    doc = Nokogiri::HTML formulaire
    text = doc.at('textarea').text
    self.production_in_formulaire = !text.blank?
    # Somewhere else
    http_found = false
    http_found = true if 'http'.in? formulaire
    parcoursup_lettre_motivation = parcoursup_clean('lettre_motivation')
    http_found = true if 'http'.in? parcoursup_lettre_motivation
    self.production_somewhere_else = http_found
    # Auto attribute modifier
    if !self.production_in_formulaire && !self.production_somewhere_else
      self.production_id = 5
      self.evaluation_comment = 'Pas de production en ligne'
      self.evaluation_done = true
    end
    # Analyzed
    self.production_analyzed = true
    save
  end

  def parcoursup(part)
    key = parcoursup_part_to_key(part)
    self.send key
  end

  def parcoursup_clean(part)
    raw = parcoursup part
    return '' if raw.nil?
    doc = Nokogiri::HTML raw
    doc.xpath('//script').remove
    doc.xpath('//style').remove
    doc.at('body').inner_html
  end

  def parcoursup_load(part)
    Parcoursup.instance.load_page(number, part)
  end

  def parcoursup_synthesis_lettre_motivation
    letter = parcoursup_clean 'lettre_motivation'
    doc = Nokogiri::HTML letter
    doc.at('#div_lm_consult').inner_html
  end

  def parcoursup_synthesis_formulaire
    formulaire = parcoursup_clean 'formulaire'
    doc = Nokogiri::HTML formulaire
    doc.at('.divGlobalFormulaire').inner_html
  end

  def decile_delta
    return 0 if selection_decile.nil?
    selection_decile - interview_decile
  end

  def large_decile_delta?
    decile_delta.abs > DECILE_DELTA_THRESHOLD
  end

  def decile_good_surprise?
    decile_delta > DECILE_DELTA_THRESHOLD
  end

  def decile_bad_surprise?
    decile_delta < -DECILE_DELTA_THRESHOLD
  end

  def to_s
    "#{first_name} #{last_name}"
  end

  protected

  def self.set_positions_in_list_by_key(list, note_key, position_key, decile_key = nil)
    current_note = nil
    current_position = 0
    list.each do |candidate|
      candidate_note = candidate.send(note_key)
      if candidate_note != current_note
        current_note = candidate_note
        current_position += 1
      end
      candidate.update_column position_key, current_position
    end
  end

  def self.set_deciles(list, decile_key)
    return if decile_key.nil?
    current_decile = 10
    current_decile_count = 0
    quantity_per_decile = (list.count / 10.0).ceil
    list.each do |candidate|
      candidate.update_column decile_key, current_decile
      current_decile_count += 1
      if current_decile_count >= quantity_per_decile
        current_decile_count = 0
        current_decile -= 1
      end
    end
  end

  def parcoursup_part_to_key(part)
    "parcoursup_#{part.underscore}".to_sym
  end

  def denormalize_notes
    self.evaluation_note = compute_evaluation_note
    self.interview_note = compute_interview_note
    # Should be that
    # self.selection_note = self.evaluation_note + self.interview_note
    # Is that
    self.selection_note = self.interview_note
  end

  def compute_evaluation_note
    note = dossier_note
    note += attitude&.value.to_f + intention&.value.to_f + production&.value.to_f + localization&.value.to_f
    note += Setting.first.evaluation_scholarship_bonus if scholarship
    note += baccalaureat.inherited_evaluation_bonus if baccalaureat.inherited_evaluation_bonus
    note
  end

  def compute_interview_note
    note = 0
    note += Setting.first.interview_bonus if interview_bonus
    Modifier::KINDS_INTERVIEW.each do |kind|
      property = send kind
      next if property.nil?
      note += property.value
    end
    note
  end
end
