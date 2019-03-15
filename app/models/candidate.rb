# == Schema Information
#
# Table name: candidates
#
#  id              :bigint(8)        not null, primary key
#  number          :string
#  first_name      :string
#  last_name       :string
#  baccalaureat_id :bigint(8)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Candidate < ApplicationRecord
  belongs_to :baccalaureat

  scope :search, -> (term) {where('unaccent(first_name) ILIKE unaccent(?) OR unaccent(last_name) ILIKE unaccent(?)', "%#{term}%", "%#{term}%")}

  def to_s
    "#{first_name} #{last_name}"
  end
end
