require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test 'from_string' do
    m = Message.from_string('ruby-list', 1, <<END)
Subject: [ruby-list:1] Hello
From: alice@...
Date: Mon, 01 Jan 2022 12:34:56 +0900

Hello, world!
END
    assert_equal "Hello, world!\n", m.body
    assert_nil m.id
  end
end
