# == Schema Information
#
# Table name: modifiers
#
#  id          :bigint(8)        not null, primary key
#  title       :string
#  description :string
#  value       :float
#  kind        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Modifier < ApplicationRecord
  KIND_ATTITUDE = 'attitude'
  KIND_INTENTION = 'intention'
  KIND_PRODUCTION = 'production'
  KIND_LOCALIZATION = 'localization'
  KIND_INTERVIEW_KNOWLEDGE = 'interview_knowledge'
  KIND_INTERVIEW_PROJECT = 'interview_project'
  KIND_INTERVIEW_MOTIVATION = 'interview_motivation'
  KIND_INTERVIEW_CULTURE = 'interview_culture'
  KIND_INTERVIEW_ARGUMENT = 'interview_argument'

  KINDS_EVALUATION = [
    KIND_ATTITUDE,
    KIND_INTENTION,
    KIND_PRODUCTION,
    KIND_LOCALIZATION
  ]

  KINDS_INTERVIEW = [
    KIND_INTERVIEW_KNOWLEDGE,
    KIND_INTERVIEW_PROJECT,
    KIND_INTERVIEW_MOTIVATION,
    KIND_INTERVIEW_CULTURE,
    KIND_INTERVIEW_ARGUMENT
  ]

  KINDS_EVALUATION_LABELS = [
    'Qualité du parcours scolaire',
    'Projet de formation motivé',
    'Intérêt du projet en ligne',
    'Motivation pour la spécialité'
  ]

  KINDS_INTERVIEW_LABELS = [
    '1. Connaissances de la formation',
    '2. Construction du projet professionnel',
    '3. Motivation',
    '4. Curiosité et culture générale / MMI',
    '5. Capacité d’argumentation et de conviction'
  ]

  KINDS = [
    KIND_ATTITUDE,
    KIND_INTENTION,
    KIND_PRODUCTION,
    KIND_LOCALIZATION,
    KIND_INTERVIEW_KNOWLEDGE,
    KIND_INTERVIEW_PROJECT,
    KIND_INTERVIEW_MOTIVATION,
    KIND_INTERVIEW_CULTURE,
    KIND_INTERVIEW_ARGUMENT
  ]

  validates_presence_of :title, :value, :kind

  scope :attitude, -> { where(kind: KIND_ATTITUDE) }
  scope :intention, -> { where(kind: KIND_INTENTION) }
  scope :production, -> { where(kind: KIND_PRODUCTION) }
  scope :localization, -> { where(kind: KIND_LOCALIZATION) }
  scope :interview_knowledge, -> { where(kind: KIND_INTERVIEW_KNOWLEDGE) }
  scope :interview_project, -> { where(kind: KIND_INTERVIEW_PROJECT) }
  scope :interview_motivation, -> { where(kind: KIND_INTERVIEW_MOTIVATION) }
  scope :interview_culture, -> { where(kind: KIND_INTERVIEW_CULTURE) }
  scope :interview_argument, -> { where(kind: KIND_INTERVIEW_ARGUMENT) }

  default_scope -> { order(:kind, value: :desc) }

  def self.label(kind)
    if kind.in? KINDS_EVALUATION
      KINDS_EVALUATION_LABELS[KINDS_EVALUATION.find_index(kind)]
    elsif kind.in? KINDS_INTERVIEW
      KINDS_INTERVIEW_LABELS[KINDS_INTERVIEW.find_index(kind)]
    end
  end

  def title_and_description
    "#{title} (#{description})"
  end

  def candidates
    unless @candidates
      @candidates = Candidate.joins(:evaluations)
      @candidates = @candidates.where("evaluations.#{kind}_id = #{id}") if kind.in? KINDS_EVALUATION
    end
    @candidates
  end

  def to_s
    title_and_description
  end
end
