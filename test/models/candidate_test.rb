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
#  production_in_formulaire             :boolean          default(FALSE)
#  production_somewhere_else            :boolean          default(FALSE)
#  production_analyzed                  :boolean          default(FALSE)
#  attributed_to_id                     :bigint(8)
#  evaluation_done                      :boolean          default(FALSE)
#  interview_done                       :boolean          default(FALSE)
#  interview_comment                    :text
#  interview_position                   :integer
#  interview_note                       :float
#  interview_knowledge_id               :integer
#  interview_project_id                 :integer
#  interview_motivation_id              :integer
#  interview_culture_id                 :integer
#  interview_argument_id                :integer
#  interview_bonus                      :boolean          default(FALSE)
#  selection_note                       :float
#  selection_position                   :integer
#  evaluation_decile                    :integer
#  interview_decile                     :integer
#  selection_decile                     :integer
#  evaluation_selected                  :boolean          default(FALSE)
#  interview_selected                   :boolean          default(FALSE)
#  selection_selected                   :boolean          default(FALSE)
#

require 'test_helper'

class CandidateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
