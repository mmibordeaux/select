# == Schema Information
#
# Table name: candidates
#
#  id                 :bigint(8)        not null, primary key
#  number             :string
#  first_name         :string
#  last_name          :string
#  baccalaureat_id    :bigint(8)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  dossier_note       :float            default(0.0)
#  evaluation_note    :float            default(0.0)
#  evaluation_comment :text             default("")
#  evaluated_by_id    :bigint(8)
#  level              :text
#  attitude_id        :bigint(8)
#  intention_id       :bigint(8)
#  production_id      :bigint(8)
#  localization_id    :bigint(8)
#  position           :integer
#  dossier_id         :string
#

require 'test_helper'

class CandidateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
