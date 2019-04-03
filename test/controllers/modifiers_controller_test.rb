require 'test_helper'

class ModifiersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @modifier = modifiers(:one)
  end

  test "should get index" do
    get modifiers_url
    assert_response :success
  end

  test "should get new" do
    get new_modifier_url
    assert_response :success
  end

  test "should create modifier" do
    assert_difference('Modifier.count') do
      post modifiers_url, params: { modifier: { description: @modifier.description, kind: @modifier.kind, title: @modifier.title, value: @modifier.value } }
    end

    assert_redirected_to modifier_url(Modifier.last)
  end

  test "should show modifier" do
    get modifier_url(@modifier)
    assert_response :success
  end

  test "should get edit" do
    get edit_modifier_url(@modifier)
    assert_response :success
  end

  test "should update modifier" do
    patch modifier_url(@modifier), params: { modifier: { description: @modifier.description, kind: @modifier.kind, title: @modifier.title, value: @modifier.value } }
    assert_redirected_to modifier_url(@modifier)
  end

  test "should destroy modifier" do
    assert_difference('Modifier.count', -1) do
      delete modifier_url(@modifier)
    end

    assert_redirected_to modifiers_url
  end
end
