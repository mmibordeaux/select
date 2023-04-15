# == Schema Information
#
# Table name: evaluations
#
#  id              :bigint           not null, primary key
#  boost           :boolean          default(FALSE)
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
require 'test_helper'

class EvaluationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
