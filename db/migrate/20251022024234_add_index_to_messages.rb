class AddIndexToMessages < ActiveRecord::Migration[8.0]
  def change
    add_index :messages, :message_id_header
  end
end
