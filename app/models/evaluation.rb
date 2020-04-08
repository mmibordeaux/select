class Evaluation < ApplicationRecord
  belongs_to :candidate
  belongs_to :user

  belongs_to :attitude, class_name: 'Modifier', optional: true
  belongs_to :intention, class_name: 'Modifier', optional: true
  belongs_to :production, class_name: 'Modifier', optional: true
  belongs_to :localization, class_name: 'Modifier', optional: true

  validates_presence_of :comment
  validates_presence_of :attitude
  validates_presence_of :intention
  validates_presence_of :production
  validates_presence_of :localization
  validates_length_of :comment, minimum: 15, allow_blank: false, on: :evaluation

  before_validation :compute_note
  after_save :save_candidate

  protected

  def compute_note
    self.note = attitude&.value.to_f + intention&.value.to_f + production&.value.to_f + localization&.value.to_f
  end

  def save_candidate
    candidate.save
  end
end
