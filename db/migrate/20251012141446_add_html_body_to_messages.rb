class AddHtmlBodyToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :html_body, :text
  end
end
