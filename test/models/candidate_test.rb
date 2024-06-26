# == Schema Information
#
# Table name: candidates
#
#  id                                   :bigint           not null, primary key
#  baccalaureat_mention                 :string
#  data                                 :jsonb
#  dossier_note                         :float            default(0.0)
#  evaluation_comment                   :text             default("")
#  evaluation_decile                    :integer
#  evaluation_done                      :boolean          default(FALSE)
#  evaluation_note                      :float            default(0.0)
#  evaluation_selected                  :boolean          default(FALSE)
#  evaluations_count                    :integer          default(0)
#  first_name                           :string
#  gender                               :string
#  interview_bonus                      :boolean          default(FALSE)
#  interview_comment                    :text
#  interview_decile                     :integer
#  interview_done                       :boolean          default(FALSE)
#  interview_note                       :float
#  interview_position                   :integer
#  interview_selected                   :boolean          default(FALSE)
#  last_name                            :string
#  level                                :text
#  number                               :string
#  parcoursup_activites_centres_interet :text
#  parcoursup_ael                       :text
#  parcoursup_bac                       :text
#  parcoursup_bulletins                 :text
#  parcoursup_documents                 :text
#  parcoursup_entete                    :text
#  parcoursup_formulaire                :text
#  parcoursup_groupe                    :text
#  parcoursup_lettre_motivation         :text
#  parcoursup_scolarite                 :text
#  position                             :integer
#  production_analyzed                  :boolean          default(FALSE)
#  production_in_formulaire             :boolean          default(FALSE)
#  production_somewhere_else            :boolean          default(FALSE)
#  promotion_decile                     :integer
#  promotion_position                   :integer
#  promotion_selected                   :boolean          default(FALSE)
#  scholarship                          :boolean          default(FALSE)
#  selection_decile                     :integer
#  selection_note                       :float
#  selection_position                   :integer
#  selection_selected                   :boolean          default(FALSE)
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  baccalaureat_id                      :bigint           indexed
#  interview_argument_id                :integer
#  interview_culture_id                 :integer
#  interview_knowledge_id               :integer
#  interview_motivation_id              :integer
#  interview_project_id                 :integer
#
# Indexes
#
#  index_candidates_on_baccalaureat_id  (baccalaureat_id)
#
# Foreign Keys
#
#  fk_rails_79bec631bb  (baccalaureat_id => baccalaureats.id)
#

require 'test_helper'

class CandidateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
