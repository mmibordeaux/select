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
  KINDS = [
    KIND_ATTITUDE,
    KIND_INTENTION,
    KIND_PRODUCTION,
    KIND_LOCALIZATION
  ]

  validates_presence_of :title, :value, :kind

  scope :attitude, -> { where(kind: KIND_ATTITUDE) }
  scope :intention, -> { where(kind: KIND_INTENTION) }
  scope :production, -> { where(kind: KIND_PRODUCTION) }
  scope :localization, -> { where(kind: KIND_LOCALIZATION) }

  default_scope -> { order(:kind, value: :asc) }

  def title_and_description
    "#{title} (#{description})"
  end
end
