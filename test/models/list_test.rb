require "test_helper"

class ListTest < ActiveSupport::TestCase
  test 'name' do
    assert_equal 'ruby-list', List::find_by_name('ruby-list').name
  end

  test 'find_by_id' do
    assert_equal 'ruby-list', List.find_by_id(1).name
  end
end
