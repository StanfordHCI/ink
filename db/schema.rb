# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140916180111) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "left_pic_textpanels", force: true do |t|
    t.integer  "page_id"
    t.string   "panel_name"
    t.integer  "display"
    t.text     "info"
    t.string   "file"
    t.text     "caption"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "left_pic_textpanels", ["page_id"], name: "index_left_pic_textpanels_on_page_id", using: :btree

  create_table "m_selectpanels", force: true do |t|
    t.integer  "page_id"
    t.string   "panel_name"
    t.integer  "display"
    t.text     "info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "m_selectpanels", ["page_id"], name: "index_m_selectpanels_on_page_id", using: :btree

  create_table "options", force: true do |t|
    t.integer  "selectpanel_id"
    t.string   "selectpanel_type"
    t.string   "option_title"
    t.string   "file"
    t.text     "info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: true do |t|
    t.integer  "user_id"
    t.string   "site_name"
    t.text     "description"
    t.integer  "display_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "panels", force: true do |t|
    t.integer  "page_id"
    t.string   "panel_name"
    t.text     "info"
    t.integer  "display"
    t.string   "type"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "caption"
    t.string   "source"
  end

  add_index "panels", ["page_id"], name: "index_panels_on_page_id", using: :btree

  create_table "pic_caption_panels", force: true do |t|
    t.integer  "page_id"
    t.string   "panel_name"
    t.integer  "display"
    t.text     "caption"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pic_caption_panels", ["page_id"], name: "index_pic_caption_panels_on_page_id", using: :btree

  create_table "pictures", force: true do |t|
    t.integer  "page_id"
    t.string   "panel_name"
    t.integer  "display"
    t.text     "info"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pictures", ["page_id"], name: "index_pictures_on_page_id", using: :btree

  create_table "quote_panels", force: true do |t|
    t.integer  "page_id"
    t.string   "panel_name"
    t.integer  "display"
    t.text     "info"
    t.string   "source"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quote_panels", ["page_id"], name: "index_quote_panels_on_page_id", using: :btree

  create_table "s_selectpanels", force: true do |t|
    t.integer  "page_id"
    t.string   "panel_name"
    t.integer  "display"
    t.text     "info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "s_selectpanels", ["page_id"], name: "index_s_selectpanels_on_page_id", using: :btree

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "sites", force: true do |t|
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "tags", force: true do |t|
    t.integer  "page_id"
    t.integer  "panel_id"
    t.string   "panel_type"
    t.string   "name"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "text_panels", force: true do |t|
    t.integer  "page_id"
    t.string   "panel_name"
    t.integer  "display"
    t.text     "info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "text_panels", ["page_id"], name: "index_text_panels_on_page_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login"
    t.string   "password_digest"
    t.string   "salt"
    t.string   "email"
  end

end
