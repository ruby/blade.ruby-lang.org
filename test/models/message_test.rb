require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test 'from_mail' do
    mail = Mail.read_from_string(<<END_OF_BODY)
Subject: [ruby-list:1] Hello
From: alice@example.com
Date: 2005-12-15T19:32:40+09:00

Hello, world!
END_OF_BODY
    m = Message.from_mail(mail, List.find_by_name('ruby-list'), 1)
    assert_equal "Hello, world!\r\n", m.body

    assert_equal DateTime.parse('2005-12-15T19:32:40+09:00'), m.published_at
  end

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

  test 'from_s3' do
    s3_client = Aws::S3::Client.new(stub_responses: true)
    s3_client.stub_responses(:get_object, body: <<END_OF_BODY)
Subject: [ruby-list:1] Hello
From: alice@...
Date: 2005-12-15T19:32:40+09:00

Hello, world!
END_OF_BODY
    Message.from_s3(List.find_by_name('ruby-list'), 1234, s3_client)
  end

  test 'reload_from_s3' do
    s3_client = Aws::S3::Client.new(stub_responses: true)
    s3_client.stub_responses(:get_object, body: <<END_OF_BODY)
Subject: [ruby-list:1] Hello
From: alice@...
Date: 2005-12-15T19:32:40+09:00

Hello, world!
END_OF_BODY

    m = Message.new
    m.list_id = 1
    m.list_seq = 1
    m.reload_from_s3(s3_client)
    assert_equal '[ruby-list:1] Hello', m.subject
  end
end
