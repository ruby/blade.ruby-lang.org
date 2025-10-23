require "test_helper"

class AttachmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get attachments_show_url
    assert_response :success
  end
end
