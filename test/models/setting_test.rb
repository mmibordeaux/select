# == Schema Information
#
# Table name: settings
#
#  id                             :bigint           not null, primary key
#  evaluation_scholarship_bonus   :float
#  interview_bonus                :float
#  interview_number_of_candidates :integer
#  selection_gender_bonus         :integer
#  selection_number_of_candidates :integer
#  selection_scholarship_bonus    :float
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#

require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
