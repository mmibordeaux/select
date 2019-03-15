require "application_system_test_case"

class BaccalaureatsTest < ApplicationSystemTestCase
  setup do
    @baccalaureat = baccalaureats(:one)
  end

  test "visiting the index" do
    visit baccalaureats_url
    assert_selector "h1", text: "Baccalaureats"
  end

  test "creating a Baccalaureat" do
    visit baccalaureats_url
    click_on "New Baccalaureat"

    fill_in "Parent", with: @baccalaureat.parent_id
    fill_in "Quota", with: @baccalaureat.quota
    fill_in "Title", with: @baccalaureat.title
    click_on "Create Baccalaureat"

    assert_text "Baccalaureat was successfully created"
    click_on "Back"
  end

  test "updating a Baccalaureat" do
    visit baccalaureats_url
    click_on "Edit", match: :first

    fill_in "Parent", with: @baccalaureat.parent_id
    fill_in "Quota", with: @baccalaureat.quota
    fill_in "Title", with: @baccalaureat.title
    click_on "Update Baccalaureat"

    assert_text "Baccalaureat was successfully updated"
    click_on "Back"
  end

  test "destroying a Baccalaureat" do
    visit baccalaureats_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Baccalaureat was successfully destroyed"
  end
end
