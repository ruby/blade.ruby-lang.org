class AddTrigramIndex < ActiveRecord::Migration[7.1]
  def up
    # According to https://www.postgresql.org/docs/9.1/textsearch-indexes.html
    #
    # > As a rule of thumb, GIN indexes are best for static data because
    # > lookups are faster. For dynamic data, GiST indexes are faster to update.
    #
    # So we use GIN here instead of GiST.
    add_index(:messages, :body, using: :gin, opclass: { body: :gin_trgm_ops })
  end

  def down
    remove_index(:messages, :body)
  end
end
