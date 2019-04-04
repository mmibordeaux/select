# == Schema Information
#
# Table name: candidates
#
#  id                                   :bigint(8)        not null, primary key
#  number                               :string
#  first_name                           :string
#  last_name                            :string
#  baccalaureat_id                      :bigint(8)
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  dossier_note                         :float            default(0.0)
#  evaluation_note                      :float            default(0.0)
#  evaluation_comment                   :text             default("")
#  evaluated_by_id                      :bigint(8)
#  level                                :text
#  attitude_id                          :bigint(8)
#  intention_id                         :bigint(8)
#  production_id                        :bigint(8)
#  localization_id                      :bigint(8)
#  position                             :integer
#  parcoursup_entete                    :text
#  parcoursup_scolarite                 :text
#  parcoursup_activites_centres_interet :text
#  parcoursup_bac                       :text
#  parcoursup_bulletins                 :text
#  parcoursup_ael                       :text
#  parcoursup_lettre_motivation         :text
#  parcoursup_groupe                    :text
#  parcoursup_documents                 :text
#  parcoursup_formulaire                :text
#  scholarship                          :boolean          default(FALSE)
#

require 'test_helper'

class CandidateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
