class AddList < ActiveRecord::Migration[7.1]
  def change
    add_column(:messages, :list_id, :integer)
    add_column(:messages, :list_seq, :integer)
    add_index(:messages, [:list_id, :list_seq], unique: true)
  end
end
