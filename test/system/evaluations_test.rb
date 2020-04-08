require "application_system_test_case"

class EvaluationsTest < ApplicationSystemTestCase
  setup do
    @evaluation = evaluations(:one)
  end

  test "visiting the index" do
    visit evaluations_url
    assert_selector "h1", text: "Evaluations"
  end

  test "creating a Evaluation" do
    visit evaluations_url
    click_on "New Evaluation"

    fill_in "Attitude", with: @evaluation.attitude_id
    fill_in "Candidate", with: @evaluation.candidate_id
    fill_in "Comment", with: @evaluation.comment
    fill_in "Intention", with: @evaluation.intention_id
    fill_in "Localization", with: @evaluation.localization_id
    fill_in "Production", with: @evaluation.production_id
    fill_in "User", with: @evaluation.user_id
    click_on "Create Evaluation"

    assert_text "Evaluation was successfully created"
    click_on "Back"
  end

  test "updating a Evaluation" do
    visit evaluations_url
    click_on "Edit", match: :first

    fill_in "Attitude", with: @evaluation.attitude_id
    fill_in "Candidate", with: @evaluation.candidate_id
    fill_in "Comment", with: @evaluation.comment
    fill_in "Intention", with: @evaluation.intention_id
    fill_in "Localization", with: @evaluation.localization_id
    fill_in "Production", with: @evaluation.production_id
    fill_in "User", with: @evaluation.user_id
    click_on "Update Evaluation"

    assert_text "Evaluation was successfully updated"
    click_on "Back"
  end

  test "destroying a Evaluation" do
    visit evaluations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Evaluation was successfully destroyed"
  end
end
