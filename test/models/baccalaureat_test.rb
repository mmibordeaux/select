# == Schema Information
#
# Table name: baccalaureats
#
#  id         :bigint(8)        not null, primary key
#  title      :string
#  parent_id  :bigint(8)
#  quota      :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class BaccalaureatTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
