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

ActiveRecord::Schema.define(version: 20130430191323) do

  create_table "article_keywords", force: true do |t|
    t.integer  "article_id"
    t.integer  "keyword_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "article_keywords", ["article_id"], name: "index_article_keywords_on_article_id"
  add_index "article_keywords", ["keyword_id"], name: "index_article_keywords_on_keyword_id"

  create_table "articles", force: true do |t|
    t.text     "title"
    t.text     "abstract"
    t.integer  "pubmed_id"
    t.text     "raw_pubmed_xml"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "articles", ["pubmed_id"], name: "index_articles_on_pubmed_id", unique: true

  create_table "keywords", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
