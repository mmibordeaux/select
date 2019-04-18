# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  evaluator              :boolean
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :validatable

  has_many :candidates_evaluated, class_name: 'Candidate', foreign_key: :evaluated_by
  has_many :candidates_attributed, class_name: 'Candidate', foreign_key: :attributed_to_id

  scope :evaluators, -> { where(evaluator: true) }

  def evaluation_points_given
    points = 0
    Modifier::KINDS_EVALUATION.each do |criterion|
      points += evaluation_points_for criterion
    end
    points
  end

  def evaluation_points_for(criterion)
    candidates_evaluated.includes(criterion).sum('modifiers.value')
  end

  def to_s
    "#{email}"
  end
end
