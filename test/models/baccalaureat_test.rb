# == Schema Information
#
# Table name: baccalaureats
#
#  id               :bigint           not null, primary key
#  evaluation_bonus :float
#  quota            :float
#  selection_bonus  :float
#  title            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  parent_id        :bigint           indexed
#
# Indexes
#
#  index_baccalaureats_on_parent_id  (parent_id)
#
# Foreign Keys
#
#  fk_rails_6647df8d93  (parent_id => baccalaureats.id)
#

require 'test_helper'

class BaccalaureatTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
