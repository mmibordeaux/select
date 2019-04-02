# == Schema Information
#
# Table name: candidates
#
#  id                      :bigint(8)        not null, primary key
#  number                  :string
#  first_name              :string
#  last_name               :string
#  baccalaureat_id         :bigint(8)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  dossier_note            :float            default(0.0)
#  evaluation_attitude     :float            default(0.0)
#  evaluation_intention    :float            default(0.0)
#  evaluation_production   :float            default(0.0)
#  evaluation_localization :float            default(0.0)
#  evaluation_note         :float            default(0.0)
#  evaluation_comment      :text             default("")
#  evaluated_by_id         :bigint(8)
#

require 'test_helper'

class CandidateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
