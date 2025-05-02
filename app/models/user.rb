# == Schema Information
#
# Table name: users
#
#  id                              :bigint           not null, primary key
#  email                           :string           default(""), not null, indexed
#  encrypted_password              :string           default(""), not null
#  evaluator                       :boolean
#  first_evaluation_baccalaureats  :string
#  first_evaluation_quota          :integer
#  first_name                      :string
#  last_name                       :string
#  remember_created_at             :datetime
#  reset_password_sent_at          :datetime
#  reset_password_token            :string           indexed
#  second_evaluation_baccalaureats :string
#  second_evaluation_quota         :integer
#  signature                       :text
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :evaluations
  has_many  :candidates,
            class_name: 'Candidate',
            through: :evaluations

  has_and_belongs_to_many :candidates_interviewed, class_name: 'Candidate'

  scope :evaluators, -> { where(evaluator: true) }
  scope :ordered, -> { order(:last_name, :first_name) }

  def candidates_evaluated
    Candidate.where(id: evaluations.done.pluck(:candidate_id))
  end

  def candidates_attributed
    Candidate.where(id: evaluations.pluck(:candidate_id))
  end

  # Evaluation

  def evaluation_points_given
    evaluations.sum :note
  end

  def evaluation_points_for(criterion)
    evaluations.includes(criterion).sum('modifiers.value')
  end

  def evaluation_points_average_for(criterion)
    return 0 if candidates_evaluated.none?
    1.0 * evaluation_points_for(criterion) / candidates_evaluated.count
  end

  def evaluation_points_given_average
    return 0 if candidates_evaluated.none?
    1.0 * evaluation_points_given / candidates_evaluated.count
  end

  def evaluation_modifier_used(modifier)
    evaluations.where("#{modifier.kind}_id" => modifier.id).count
  end

  # Interview

  def interview_points_given
    unless @interview_points_given
      @interview_points_given = 0
      Modifier::KINDS_INTERVIEW.each do |criterion|
        @interview_points_given += interview_points_for criterion
      end
    end
    @interview_points_given
  end

  def interview_points_for(criterion)
    candidates_interviewed.includes(criterion).sum('modifiers.value')
  end

  def interview_points_average_for(criterion)
    return 0.0 if candidates_interviewed.none?
    1.0 * interview_points_for(criterion) / candidates_interviewed.count
  end

  def interview_points_given_average
    return 0.0 if candidates_interviewed.none?
    1.0 * interview_points_given / candidates_interviewed.count
  end

  def interview_modifier_used(modifier)
    candidates_interviewed.where("#{modifier.kind}_id" => modifier.id).count
  end

  def to_s
    first_name.blank? ? "#{email}"
                      : "#{first_name} #{last_name}"
  end
end
