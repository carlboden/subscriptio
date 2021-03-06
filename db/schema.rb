# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_01_122206) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "bank_details", force: :cascade do |t|
    t.date "expiration_date"
    t.string "cvv"
    t.bigint "company_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "card"
    t.index ["company_id"], name: "index_bank_details_on_company_id"
    t.index ["user_id"], name: "index_bank_details_on_user_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "country"
    t.string "company_size"
    t.string "turnover"
    t.bigint "subscriptio_plan_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["subscriptio_plan_id"], name: "index_companies_on_subscriptio_plan_id"
  end

  create_table "features", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "rating"
    t.text "description"
    t.bigint "user_id", null: false
    t.bigint "software_plan_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["software_plan_id"], name: "index_ratings_on_software_plan_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "software_features", force: :cascade do |t|
    t.bigint "software_plan_id", null: false
    t.bigint "feature_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["feature_id"], name: "index_software_features_on_feature_id"
    t.index ["software_plan_id"], name: "index_software_features_on_software_plan_id"
  end

  create_table "software_plans", force: :cascade do |t|
    t.float "official_price"
    t.string "name"
    t.bigint "software_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["software_id"], name: "index_software_plans_on_software_id"
  end

  create_table "softwares", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "category"
    t.string "demo_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "subscriptio_plans", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.text "description"
    t.text "features", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.float "price"
    t.bigint "company_id", null: false
    t.bigint "software_plan_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "number_of_user"
    t.index ["company_id"], name: "index_subscriptions_on_company_id"
    t.index ["software_plan_id"], name: "index_subscriptions_on_software_plan_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "function"
    t.boolean "company_admin"
    t.boolean "admin"
    t.bigint "company_id"
    t.string "status"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bank_details", "companies"
  add_foreign_key "bank_details", "users"
  add_foreign_key "companies", "subscriptio_plans"
  add_foreign_key "ratings", "software_plans"
  add_foreign_key "ratings", "users"
  add_foreign_key "software_features", "features"
  add_foreign_key "software_features", "software_plans"
  add_foreign_key "software_plans", "softwares"
  add_foreign_key "subscriptions", "companies"
  add_foreign_key "subscriptions", "software_plans"
  add_foreign_key "users", "companies"
end
