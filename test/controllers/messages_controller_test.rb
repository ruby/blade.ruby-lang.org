require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @message = messages(:message1)
  end

  test "should get index" do
    get messages_url
    assert_response :success
  end
end
