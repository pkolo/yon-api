# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180310214144) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"

  create_table "albums", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "discog_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "year"
    t.string "slug"
    t.float "yachtski"
    t.index ["title"], name: "index_albums_on_title"
  end

  create_table "credits", id: :serial, force: :cascade do |t|
    t.string "role", null: false
    t.integer "personnel_id"
    t.integer "creditable_id"
    t.string "creditable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["creditable_type", "creditable_id"], name: "index_credits_on_creditable_type_and_creditable_id"
    t.index ["personnel_id"], name: "index_credits_on_personnel_id"
  end

  create_table "episodes", id: :serial, force: :cascade do |t|
    t.string "number"
    t.text "notes"
    t.string "link"
    t.string "data_id"
    t.bigint "show_id"
    t.integer "episode_no"
    t.date "air_date"
    t.string "title"
    t.index ["show_id"], name: "index_episodes_on_show_id"
  end

  create_table "episodes_songs", id: false, force: :cascade do |t|
    t.bigint "song_id", null: false
    t.bigint "episode_id", null: false
  end

  create_table "personnels", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "discog_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "slug"
    t.float "yachtski"
    t.index ["name"], name: "index_personnels_on_name"
  end

  create_table "shows", force: :cascade do |t|
    t.string "title"
    t.string "abbreviation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "songs", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.integer "year", null: false
    t.float "dave_score", null: false
    t.float "jd_score", null: false
    t.float "hunter_score", null: false
    t.float "steve_score", null: false
    t.integer "album_id"
    t.string "track_no"
    t.string "yt_id"
    t.string "slug"
    t.text "notes"
    t.float "yachtski"
    t.jsonb "data"
    t.index ["album_id"], name: "index_songs_on_album_id"
    t.index ["title"], name: "index_songs_on_title"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "password_digest", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "token"
  end

  add_foreign_key "episodes", "shows"
end
