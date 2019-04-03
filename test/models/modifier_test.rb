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

require 'test_helper'

class ModifierTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
