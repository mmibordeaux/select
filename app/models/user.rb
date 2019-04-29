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
#  first_name             :string
#  last_name              :string
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :validatable

  has_many :candidates_evaluated, class_name: 'Candidate', foreign_key: :evaluated_by
  has_many :candidates_attributed, class_name: 'Candidate', foreign_key: :attributed_to_id

  has_and_belongs_to_many :candidates_interviewed, class_name: 'Candidate'

  scope :evaluators, -> { where(evaluator: true) }

  def evaluation_points_given
    unless @evaluation_points_given
      @evaluation_points_given = 0
      Modifier::KINDS_EVALUATION.each do |criterion|
        @evaluation_points_given += evaluation_points_for criterion
      end
    end
    @evaluation_points_given
  end

  def evaluation_points_for(criterion)
    candidates_evaluated.includes(criterion).sum('modifiers.value')
  end

  def evaluation_points_given_average
    evaluation_points_given / candidates_evaluated.count
  end

  def to_s
    first_name.blank? ? "#{email}"
                      : "#{first_name} #{last_name}"
  end
end
