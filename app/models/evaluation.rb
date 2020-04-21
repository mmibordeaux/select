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
