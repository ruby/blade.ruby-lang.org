require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test 'from_string' do
    m = Message.from_string(<<END_OF_BODY)
Subject: [ruby-list:1] Hello
From: alice@...
Date: 2005-12-15T19:32:40+09:00

Hello, world!
END_OF_BODY
    assert_equal "Hello, world!\n", m.body
    assert_nil m.id

    assert_equal DateTime.parse('2005-12-15T19:32:40+09:00'), m.published_at
  end
end
