# == Schema Information
#
# Table name: evaluations
#
#  id              :bigint           not null, primary key
#  comment         :string
#  note            :float
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  attitude_id     :bigint           indexed
#  candidate_id    :bigint           indexed
#  intention_id    :bigint           indexed
#  localization_id :bigint           indexed
#  production_id   :bigint           indexed
#  user_id         :bigint           indexed
#
# Indexes
#
#  index_evaluations_on_attitude_id      (attitude_id)
#  index_evaluations_on_candidate_id     (candidate_id)
#  index_evaluations_on_intention_id     (intention_id)
#  index_evaluations_on_localization_id  (localization_id)
#  index_evaluations_on_production_id    (production_id)
#  index_evaluations_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_0bebe2a996  (attitude_id => modifiers.id)
#  fk_rails_4d6697efce  (candidate_id => candidates.id)
#  fk_rails_524dcb2372  (localization_id => modifiers.id)
#  fk_rails_59ffdc5ee1  (intention_id => modifiers.id)
#  fk_rails_6dabaf8d1b  (production_id => modifiers.id)
#  fk_rails_ef42eba623  (user_id => users.id)
#
class Evaluation < ApplicationRecord
  belongs_to :candidate
  belongs_to :user

  belongs_to :attitude, class_name: 'Modifier', optional: true
  belongs_to :intention, class_name: 'Modifier', optional: true
  belongs_to :production, class_name: 'Modifier', optional: true
  belongs_to :localization, class_name: 'Modifier', optional: true

  validates_presence_of :comment, on: :evaluation
  validates_presence_of :attitude, on: :evaluation
  validates_presence_of :intention, on: :evaluation
  validates_presence_of :production, on: :evaluation
  validates_presence_of :localization, on: :evaluation
  validates_length_of :comment, minimum: 15, allow_blank: false, on: :evaluation

  before_validation :compute_note
  after_save :save_candidate

  scope :todo, -> { where(note: nil) }
  scope :done, -> { where.not(note: nil) }

  def done?
    !note.nil?
  end

  protected

  def compute_note
    return unless attitude && intention && production && localization
    self.note = attitude&.value.to_f + intention&.value.to_f + production&.value.to_f + localization&.value.to_f
  end

  def save_candidate
    candidate.save
  end
end
