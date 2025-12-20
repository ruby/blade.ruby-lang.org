class AddYyyymmToMessages < ActiveRecord::Migration[8.1]
  def change
    add_column :messages, :yyyymm, :integer
  end
end
