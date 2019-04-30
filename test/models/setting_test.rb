# == Schema Information
#
# Table name: settings
#
#  id                             :bigint(8)        not null, primary key
#  evaluation_scholarship_bonus   :float
#  interview_number_of_candidates :integer
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  interview_bonus                :float
#  selection_number_of_candidates :integer
#

require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
