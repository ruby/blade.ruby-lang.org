class AddPublishedAtToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :published_at, :timestamp
  end
end
