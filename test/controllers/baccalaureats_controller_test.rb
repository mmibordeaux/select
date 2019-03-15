require 'test_helper'

class BaccalaureatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @baccalaureat = baccalaureats(:one)
  end

  test "should get index" do
    get baccalaureats_url
    assert_response :success
  end

  test "should get new" do
    get new_baccalaureat_url
    assert_response :success
  end

  test "should create baccalaureat" do
    assert_difference('Baccalaureat.count') do
      post baccalaureats_url, params: { baccalaureat: { parent_id: @baccalaureat.parent_id, quota: @baccalaureat.quota, title: @baccalaureat.title } }
    end

    assert_redirected_to baccalaureat_url(Baccalaureat.last)
  end

  test "should show baccalaureat" do
    get baccalaureat_url(@baccalaureat)
    assert_response :success
  end

  test "should get edit" do
    get edit_baccalaureat_url(@baccalaureat)
    assert_response :success
  end

  test "should update baccalaureat" do
    patch baccalaureat_url(@baccalaureat), params: { baccalaureat: { parent_id: @baccalaureat.parent_id, quota: @baccalaureat.quota, title: @baccalaureat.title } }
    assert_redirected_to baccalaureat_url(@baccalaureat)
  end

  test "should destroy baccalaureat" do
    assert_difference('Baccalaureat.count', -1) do
      delete baccalaureat_url(@baccalaureat)
    end

    assert_redirected_to baccalaureats_url
  end
end
