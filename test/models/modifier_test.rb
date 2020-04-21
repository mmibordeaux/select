# == Schema Information
#
# Table name: modifiers
#
#  id          :bigint           not null, primary key
#  description :string
#  kind        :string
#  title       :string
#  value       :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class ModifierTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
