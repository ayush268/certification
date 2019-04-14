require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get all" do
    get admin_all_url
    assert_response :success
  end

end
