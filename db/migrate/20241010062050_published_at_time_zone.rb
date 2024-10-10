class PublishedAtTimeZone < ActiveRecord::Migration[7.1]
  # https://github.com/rails/rails/pull/41084
  def change
    change_column :messages, :published_at, :timestamptz
  end
end
