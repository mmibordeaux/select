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
#

class Candidate < ApplicationRecord
  belongs_to :baccalaureat
  belongs_to :evaluated_by, class_name: 'User', optional: true
  belongs_to :attitude, class_name: 'Modifier', optional: true
  belongs_to :intention, class_name: 'Modifier', optional: true
  belongs_to :production, class_name: 'Modifier', optional: true
  belongs_to :localization, class_name: 'Modifier', optional: true

  scope :search, -> (term) {where('unaccent(first_name) ILIKE unaccent(?) OR unaccent(last_name) ILIKE unaccent(?)', "%#{term}%", "%#{term}%")}
  scope :ordered_by_evaluation, -> { order(evaluation_note: :desc) }
  before_save :compute_evaluation_note

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
      candidate.save
      puts "Created candidate #{number}"
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

  def self.sync_all
    find_each do |candidate|
      candidate.parcoursup_sync! unless candidate.parcoursup_synced?
    end
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
        sleep 2
      end
    end
  end

  def parcoursup(part)
    key = parcoursup_part_to_key(part)
    self.send key
  end

  def to_s
    "#{first_name} #{last_name}"
  end

  protected

  def parcoursup_part_to_key(part)
    "parcoursup_#{part.underscore}".to_sym
  end

  def compute_evaluation_note
    self.evaluation_note =  dossier_note + attitude&.value.to_f + intention&.value.to_f + production&.value.to_f + localization&.value.to_f
  end
end
