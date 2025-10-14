class CreateActiveStorageFileBlobs < ActiveRecord::Migration[8.0]
  def change
    create_table :active_storage_file_blobs do |t|
      t.string :key
      t.binary :data

      t.timestamps
    end
    add_index :active_storage_file_blobs, :key, unique: true
  end
end
