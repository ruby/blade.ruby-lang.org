# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_12_20_091844) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_file_blobs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.binary "data"
    t.string "key"
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_active_storage_file_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "from"
    t.text "html_body"
    t.integer "list_id"
    t.integer "list_seq"
    t.string "message_id_header"
    t.integer "parent_id"
    t.timestamptz "published_at"
    t.string "subject"
    t.datetime "updated_at", null: false
    t.integer "yyyymm"
    t.index ["body"], name: "index_messages_on_body", opclass: :gin_trgm_ops, using: :gin
    t.index ["list_id", "list_seq"], name: "index_messages_on_list_id_and_list_seq", unique: true
    t.index ["list_id", "parent_id"], name: "index_messages_on_list_id_and_parent_id"
    t.index ["message_id_header"], name: "index_messages_on_message_id_header"
    t.index ["parent_id"], name: "index_messages_on_parent_id"
    t.index ["yyyymm"], name: "index_messages_on_yyyymm"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
