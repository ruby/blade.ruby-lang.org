class AddIndexesToMessages < ActiveRecord::Migration[8.1]
  def change
    add_index :messages, [:list_id, :parent_id]
    add_index :messages, :parent_id
  end
end
