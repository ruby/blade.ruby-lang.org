class AddMessageIdHeaderAndParentIdToMessage < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :message_id_header, :string
    add_column :messages, :parent_id, :integer
  end
end
