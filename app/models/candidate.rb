# == Schema Information
#
# Table name: candidates
#
#  id                 :bigint(8)        not null, primary key
#  number             :string
#  first_name         :string
#  last_name          :string
#  baccalaureat_id    :bigint(8)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  dossier_note       :float            default(0.0)
#  evaluation_note    :float            default(0.0)
#  evaluation_comment :text             default("")
#  evaluated_by_id    :bigint(8)
#  level              :text
#  attitude_id        :bigint(8)
#  intention_id       :bigint(8)
#  production_id      :bigint(8)
#  localization_id    :bigint(8)
#

class Candidate < ApplicationRecord
  # EVALUATION_ATTITUDE = [
  #   ['comportement problématique (insolence, trop de bavardage, manque de travail…)', -5.0],
  #   ['excellent comportement (étudiant pro-actif, moteur, participation…)', 2.0]
  # ]

  # EVALUATION_INTENTION = [
  #   ['projet flou et candidature non motivée', 0.0],
  #   ['projet professionnel clairement identifié (connaissance des métiers, rencontre de professionnels, activités en lien avec MMI et bonne culture web : les coulisses du web…)', 3.0]
  # ]

  # EVALUATION_PRODUCTION = [
  #   ['pas de production en ligne', 0.0],
  #   ['excellentes productions en ligne qui mettent en valeur les compétences du candidat sur le fond (portfolio qui parle du projet professionnel) mais également la forme (site type wixi/tumblr ou cms ou développé en code, vidéo de bonne qualité, blog avec rédactionnel...)', 5.0]
  # ]

  # EVALUATION_LOCALIZATION = [
  #   ['ne s’est pas suffisamment renseigné sur MMI Bordeaux', 0.0],
  #   ['a participé aux JPO, raisons personnelles de s’installer à Bordeaux...', 2.0]
  # ]

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
      candidate = Candidate.where(number: number).first_or_create
      candidate.first_name = first_name
      candidate.last_name = last_name
      candidate.baccalaureat = baccalaureat
      candidate.level = level
      candidate.save
      puts "Created candidate #{number}"
    end
  end

  def parcoursup_url
    "https://gestion.parcoursup.fr/#{number}"
  end

  def to_s
    "#{first_name} #{last_name}"
  end

  protected

  def compute_evaluation_note
    self.evaluation_note =  dossier_note + attitude&.value.to_f + intention&.value.to_f + production&.value.to_f + localization&.value.to_f
  end
end
