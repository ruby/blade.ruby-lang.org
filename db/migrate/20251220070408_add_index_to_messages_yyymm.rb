class AddIndexToMessagesYyymm < ActiveRecord::Migration[8.1]
  def change
    add_index :messages, :yyyymm
  end
end
