require 'test_helper'

class CreditCardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get credit_card_index_url
    assert_response :success
  end

end
