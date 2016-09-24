require 'test_helper'

class TournamentRegistrationControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tournament_registration_index_url
    assert_response :success
  end

end
