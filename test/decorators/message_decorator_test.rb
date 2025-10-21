# frozen_string_literal: true

require 'test_helper'

class MessageDecoratorTest < ActiveSupport::TestCase
  def setup
    @message = Message.new.extend MessageDecorator
  end

  # test "the truth" do
  #   assert true
  # end
end
