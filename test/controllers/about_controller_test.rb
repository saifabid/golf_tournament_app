require 'test_helper'

class AboutControllerTest < ActionDispatch::IntegrationTest
  test "should get company" do
    get about_company_url
    assert_response :success
  end

  test "should get features" do
    get about_features_url
    assert_response :success
  end

  test "should get faq" do
    get about_faq_url
    assert_response :success
  end

  test "should get partners" do
    get about_partners_url
    assert_response :success
  end

end
