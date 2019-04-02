# == Schema Information
#
# Table name: candidates
#
#  id                      :bigint(8)        not null, primary key
#  number                  :string
#  first_name              :string
#  last_name               :string
#  baccalaureat_id         :bigint(8)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  dossier_note            :float            default(0.0)
#  evaluation_attitude     :float            default(0.0)
#  evaluation_intention    :float            default(0.0)
#  evaluation_production   :float            default(0.0)
#  evaluation_localization :float            default(0.0)
#  evaluation_note         :float            default(0.0)
#  evaluation_comment      :text             default("")
#  evaluated_by_id         :bigint(8)
#

class Candidate < ApplicationRecord
  EVALUATION_ATTITUDE = [
    ['comportement problématique (insolence, trop de bavardage, manque de travail…)', -5.0],
    ['excellent comportement (étudiant pro-actif, moteur, participation…)', 2.0]
  ]

  EVALUATION_INTENTION = [
    ['projet flou et candidature non motivée', 0.0],
    ['projet professionnel clairement identifié (connaissance des métiers, rencontre de professionnels, activités en lien avec MMI et bonne culture web : les coulisses du web…)', 3.0]
  ]

  EVALUATION_PRODUCTION = [
    ['pas de production en ligne', 0.0],
    ['excellentes productions en ligne qui mettent en valeur les compétences du candidat sur le fond (portfolio qui parle du projet professionnel) mais également la forme (site type wixi/tumblr ou cms ou développé en code, vidéo de bonne qualité, blog avec rédactionnel...)', 5.0]
  ]

  EVALUATION_LOCALIZATION = [
    ['ne s’est pas suffisamment renseigné sur MMI Bordeaux', 0.0],
    ['a participé aux JPO, raisons personnelles de s’installer à Bordeaux...', 2.0]
  ]

  belongs_to :baccalaureat
  belongs_to :evaluated_by, class_name: 'User'

  scope :search, -> (term) {where('unaccent(first_name) ILIKE unaccent(?) OR unaccent(last_name) ILIKE unaccent(?)', "%#{term}%", "%#{term}%")}
  scope :ordered_by_evaluation, -> { order(evaluation_note: :desc) }
  before_save :compute_evaluation_note

  def parcoursup_url
    "https://parcoursup/#{number}"
  end

  def to_s
    "#{first_name} #{last_name}"
  end

  protected

  def compute_evaluation_note
    self.evaluation_note =  dossier_note + evaluation_attitude + evaluation_intention + evaluation_production + evaluation_localization
  end
end
