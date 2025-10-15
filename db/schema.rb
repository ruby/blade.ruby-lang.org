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

ActiveRecord::Schema[7.1].define(version: 2024_10_10_062050) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "messages", force: :cascade do |t|
    t.string "subject"
    t.string "from"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "list_id"
    t.integer "list_seq"
    t.timestamptz "published_at"
    t.index ["body"], name: "index_messages_on_body", opclass: :gin_trgm_ops, using: :gin
    t.index ["list_id", "list_seq"], name: "index_messages_on_list_id_and_list_seq", unique: true
  end

end
