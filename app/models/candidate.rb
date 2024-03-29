# == Schema Information
#
# Table name: candidates
#
#  id                                   :bigint           not null, primary key
#  baccalaureat_mention                 :string
#  dossier_note                         :float            default(0.0)
#  evaluation_comment                   :text             default("")
#  evaluation_decile                    :integer
#  evaluation_done                      :boolean          default(FALSE)
#  evaluation_note                      :float            default(0.0)
#  evaluation_selected                  :boolean          default(FALSE)
#  evaluations_count                    :integer          default(0)
#  first_name                           :string
#  gender                               :string
#  interview_bonus                      :boolean          default(FALSE)
#  interview_comment                    :text
#  interview_decile                     :integer
#  interview_done                       :boolean          default(FALSE)
#  interview_note                       :float
#  interview_position                   :integer
#  interview_selected                   :boolean          default(FALSE)
#  last_name                            :string
#  level                                :text
#  number                               :string
#  parcoursup_activites_centres_interet :text
#  parcoursup_ael                       :text
#  parcoursup_bac                       :text
#  parcoursup_bulletins                 :text
#  parcoursup_documents                 :text
#  parcoursup_entete                    :text
#  parcoursup_formulaire                :text
#  parcoursup_groupe                    :text
#  parcoursup_lettre_motivation         :text
#  parcoursup_scolarite                 :text
#  position                             :integer
#  production_analyzed                  :boolean          default(FALSE)
#  production_in_formulaire             :boolean          default(FALSE)
#  production_somewhere_else            :boolean          default(FALSE)
#  promotion_decile                     :integer
#  promotion_position                   :integer
#  promotion_selected                   :boolean          default(FALSE)
#  scholarship                          :boolean          default(FALSE)
#  selection_decile                     :integer
#  selection_note                       :float
#  selection_position                   :integer
#  selection_selected                   :boolean          default(FALSE)
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  baccalaureat_id                      :bigint           indexed
#  interview_argument_id                :integer
#  interview_culture_id                 :integer
#  interview_knowledge_id               :integer
#  interview_motivation_id              :integer
#  interview_project_id                 :integer
#
# Indexes
#
#  index_candidates_on_baccalaureat_id  (baccalaureat_id)
#
# Foreign Keys
#
#  fk_rails_79bec631bb  (baccalaureat_id => baccalaureats.id)
#

class Candidate < ApplicationRecord

  DECILE_DELTA_THRESHOLD = 3
  GENDER_WOMAN = 'Féminin'
  GENDER_MAN = 'Masculin'

  belongs_to :baccalaureat
  has_many :evaluations, dependent: :destroy
  has_and_belongs_to_many :interviewers, class_name: 'User'

  scope :women, -> { where(gender: GENDER_WOMAN) }
  scope :men, -> { where(gender: GENDER_MAN) }

  scope :with_baccalaureat, -> (baccalaureat) { where(baccalaureat_id: baccalaureat.children_ids) }
  scope :tech, -> { with_baccalaureat(Baccalaureat.tech) }
  scope :gen, -> { with_baccalaureat(Baccalaureat.gen) }

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
  scope :scholars, -> { where(scholarship: true) }
  scope :ordered_by_date, -> { order(updated_at: :desc) }
  scope :ordered_by_evaluation, -> { order(evaluation_note: :desc) }
  scope :ordered_by_interview, -> { order(interview_note: :desc, evaluation_note: :desc) }
  scope :ordered_by_selection, -> { order(selection_note: :desc, interview_note: :desc, evaluation_note: :desc) }
  scope :ordered_by_promotion, -> { order(selection_note: :desc, interview_note: :desc, evaluation_note: :desc) }

  scope :parcoursup_synced, -> { where.not(parcoursup_formulaire: nil)}

  scope :with_no_evaluation, -> { includes(:evaluations).where(evaluations: {id: nil}) }
  scope :evaluation_todo, -> { where(evaluations_count: 0)}
  scope :evaluation_done, -> { where.not(evaluations_count: 0)}
  scope :evaluated_once, -> { where(evaluations_count: 1)}
  scope :evaluated_and_disqualified, -> {
    joins(:evaluations)
    .where("evaluations.attitude_id = 1
            OR evaluations.production_id = 5
            OR evaluations.intention_id = 10
            OR evaluations.localization_id = 11")
  }
  scope :evaluated_and_not_disqualified, -> { where.not(id: Candidate.evaluated_and_disqualified) }
  scope :evaluated_once_or_more, -> { where('candidates.evaluations_count > 0')}
  scope :evaluated_twice_or_more, -> { where('candidates.evaluations_count > 1')}
  scope :not_evaluated_twice, -> { where('candidates.evaluations_count < 2')}
  scope :evaluation_selected, -> { where(evaluation_selected: true) }

  scope :interview_todo, -> { where(interview_done: false)}
  scope :interview_done, -> { where(interview_done: true)}
  scope :interview_selected, -> { where(interview_selected: true) }
  scope :interview_bonus, -> { where(interview_bonus: true) }

  scope :selection_selected, -> { where(selection_selected: true) }

  scope :promotion_selected, -> { where(promotion_selected: true) }

  before_save :denormalize_notes

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
      number = row['Candidat - Code']
      validated = row['Vœu confirmé - Libellé'].to_s == 'Validée'
      if validated
        groupe = row['Groupe candidat - Code']
        type = groupe == '141307' ? Baccalaureat::TECH
                                  : Baccalaureat::GEN
        baccalaureat = Baccalaureat.with_title_and_parent(type, nil)
        # Terminale, 1ere année d'études supérieures...
        # Attention, espace initial dans le libellé
        niveau_etude = row[' Niveau Etude - Libellé 2022/2023']
        # Terminale, Année préparatoire aux études supérieures, BUT...
        type_formation = row['Type Formation - Libellé  2022/2023']
        # Série Générale, Sciences et Technologies de l'Industrie et du Développement Durable, Bac pro...
        serie = row['Série - Libellé']
        # Uniquement pour certains bacs : Système informatique et numérique, Energies et environnement...
        specialite = row['Spécialité / Mention - Libellé  2022/2023']
        # Bacs
        title = serie
        unless title.blank?
          baccalaureat = Baccalaureat.with_title_and_parent(title, baccalaureat)
          title = specialite
          unless title.blank?
            baccalaureat = Baccalaureat.with_title_and_parent(title, baccalaureat)
          end
        end
        # Niveau 
        level = ""
        level += niveau_etude if niveau_etude.present?
        level += " - #{type_formation}" if type_formation.present? && (type_formation != niveau_etude)
        level += " - #{serie}" if serie.present?
        level += " - #{specialite}" if specialite.present?
        # Infos
        first_name = row['Candidat - Prénom']
        last_name = row['Candidat - Nom']
        gender = row['Sexe']
        baccalaureat_mention = row['Mention Obtenue - Libellé']
        scholarship = row['Candidat boursier - Libellé'].to_s == 'Boursier de l\'enseignement scolaire'
        # Création
        candidate = Candidate.where(number: number).first_or_create
        candidate.gender = gender
        candidate.first_name = first_name
        candidate.last_name = last_name
        candidate.baccalaureat_mention = baccalaureat_mention
        candidate.baccalaureat = baccalaureat
        candidate.level = level
        candidate.scholarship = scholarship
        candidate.dossier_note = Note.average(row)
        if candidate.valid?
          puts "Created candidate #{number}"
          candidate.save
        else
          byebug
        end
      else
        Candidate.where(number: number).destroy_all
        puts "Deleted candidate #{number}"
      end
    end
  end

  def self.positionize
    # Positions
    set_positions_in_list_by_key(ordered_by_evaluation, :evaluation_note, :position)
    set_positions_in_list_by_key(ordered_by_interview, :interview_note, :interview_position)
    set_positions_in_list_by_key(ordered_by_selection, :selection_note, :selection_position)
    set_positions_in_list_by_key(ordered_by_promotion, :selection_note, :promotion_position)
    # Selections
    find_each do |candidate|
      evaluation_selected = candidate.position <= Setting.first.interview_number_of_candidates
      candidate.update_column :evaluation_selected, evaluation_selected
    end
    all.reload.ordered_by_interview.each_with_index do |candidate, index|
      # There probably should be a specific selection method for interview
      interview_selected = candidate.evaluation_selected
      candidate.update_column :interview_selected, interview_selected
    end
    all.reload.ordered_by_selection.each_with_index do |candidate, index|
      selection_selected = candidate.evaluation_selected && index <= Setting.first.selection_number_of_candidates
      candidate.update_column :selection_selected, selection_selected
    end
    # Deciles
    reset_deciles
    set_deciles(ordered_by_evaluation, :evaluation_decile)
    set_deciles(evaluation_selected.ordered_by_interview, :interview_decile)
    set_deciles(interview_selected.ordered_by_selection, :selection_decile)
    set_deciles(promotion_selected.ordered_by_promotion, :promotion_decile)
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
      puts id
      Evaluation.no_url id, 1 # Arnaud
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

  def is_there_a_document?
    ! 'Le candidat n\'a pas téléversé de document'.in?(parcoursup_documents)
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

  def woman
    gender == GENDER_WOMAN
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
    list.reload.each do |candidate|
      candidate.update_column decile_key, current_decile
      current_decile_count += 1
      if current_decile_count >= quantity_per_decile
        current_decile_count = 0
        current_decile -= 1
      end
    end
  end

  def self.reset_deciles
    update_all  evaluation_decile: nil,
                interview_decile: nil,
                selection_decile: nil
  end

  def parcoursup_part_to_key(part)
    "parcoursup_#{part.underscore}".to_sym
  end

  def denormalize_notes
    self.evaluations_count = evaluations.reload.done.count
    self.evaluation_note = compute_evaluation_note
    self.interview_note = compute_interview_note
    self.selection_note = compute_selection_note
  end

  def compute_evaluation_note
    note = dossier_note
    note += evaluations.done.average(:note) if evaluations.done.any?
    note += Setting.first.evaluation_scholarship_bonus if scholarship
    note += baccalaureat.inherited_evaluation_bonus if baccalaureat.inherited_evaluation_bonus
    note
  end

  def compute_interview_note
    note = 0
    note += Setting.first.selection_scholarship_bonus.to_f if scholarship
    note += Setting.first.interview_bonus if interview_bonus
    Modifier::KINDS_INTERVIEW.each do |kind|
      property = send kind
      next if property.nil?
      note += property.value
    end
    note
  end

  def compute_selection_note
    note = self.evaluation_note
    note += self.interview_note
    note += Setting.first.selection_gender_bonus.to_f if woman
    note += baccalaureat.inherited_selection_bonus if baccalaureat.inherited_selection_bonus
    note
  end
end
