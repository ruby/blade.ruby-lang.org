require "application_system_test_case"

class MessagesTest < ApplicationSystemTestCase
  setup do
    @message1 = messages(:message1)
    @message2 = messages(:message2)
  end

  test 'visiting ruby-dev index, and showing a message with an attachment' do
    visit '/ruby-dev'
    assert_content @message2.subject

    click_link @message2.subject
    assert_content @message2.body

    click_link @message2.attachments_attachments.first.blob.filename.to_s
  end

  test 'visiting the search page, and searching a message' do
    visit root_url
    assert_selector "h1", text: "blade.ruby-lang.org"

    fill_in :q, with: @message1.body
    click_button 'Search'

    assert_content @message1.subject
  end
end
