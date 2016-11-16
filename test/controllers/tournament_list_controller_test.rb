require 'test_helper'

class TournamentListControllerTest < ActionDispatch::IntegrationTest
  test "should get list" do
    get tournament_list_list_url
    assert_response :success
  end

end
