require 'test_helper'

class ManageControllerTest < ActionDispatch::IntegrationTest
  test "should get aboutme" do
    get manage_aboutme_url
    assert_response :success
  end

end
