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
#

class Candidate < ApplicationRecord
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
  scope :todo, -> { where(evaluation_done: false)}
  scope :done, -> { where(evaluation_done: true)}
  scope :parcoursup_synced, -> { where.not(parcoursup_formulaire: nil)}
  scope :selected_for_interviews, -> { where('position <= ?', Setting.first.interview_number_of_candidates)}

  before_save :denormalize_evaluation_note

  validates_length_of :evaluation_comment, minimum: 15, allow_blank: false, on: :evaluation
  validates_presence_of :attitude, on: :evaluation
  validates_presence_of :intention, on: :evaluation
  validates_presence_of :production, on: :evaluation
  validates_presence_of :localization, on: :evaluation

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
    current_note = nil
    current_position = 0
    ordered_by_evaluation.each do |candidate|
      if candidate.evaluation_note != current_note
        current_note = candidate.evaluation_note
        current_position += 1
      end
      candidate.update_column :position, current_position
    end
  end

  def self.recompute_evaluations
    find_each &:denormalize_evaluation_note!
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

  def denormalize_evaluation_note!
    self.update_column :evaluation_note, compute_evaluation_note
  end

  def to_s
    "#{first_name} #{last_name}"
  end

  protected

  def parcoursup_part_to_key(part)
    "parcoursup_#{part.underscore}".to_sym
  end

  def denormalize_evaluation_note
    self.evaluation_note = compute_evaluation_note
  end

  def compute_evaluation_note
    note = dossier_note
    note += attitude&.value.to_f + intention&.value.to_f + production&.value.to_f + localization&.value.to_f
    note += Setting.first.evaluation_scholarship_bonus if scholarship
    note += baccalaureat.inherited_evaluation_bonus if baccalaureat.inherited_evaluation_bonus
    note
  end
end
