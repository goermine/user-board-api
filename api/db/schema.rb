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

ActiveRecord::Schema.define(version: 2018_08_01_043855) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "user_id"
    t.string "account_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "account_number"], name: "index_accounts_on_user_id_and_account_number", unique: true
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wallet_transactions", force: :cascade do |t|
    t.integer "sender_id", null: false
    t.integer "beneficiary_id", null: false
    t.integer "wallet_from"
    t.integer "wallet_to", null: false
    t.integer "sum", null: false
    t.string "transaction_id", null: false
    t.string "method", null: false
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["beneficiary_id"], name: "index_wallet_transactions_on_beneficiary_id"
    t.index ["sender_id"], name: "index_wallet_transactions_on_sender_id"
    t.index ["wallet_from"], name: "index_wallet_transactions_on_wallet_from"
    t.index ["wallet_to"], name: "index_wallet_transactions_on_wallet_to"
  end

  create_table "wallets", force: :cascade do |t|
    t.bigint "account_id"
    t.string "wallet_number", null: false
    t.string "currency", default: "USD", null: false
    t.integer "amount", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "currency"], name: "index_wallets_on_account_id_and_currency", unique: true
    t.index ["account_id", "wallet_number"], name: "index_wallets_on_account_id_and_wallet_number", unique: true
    t.index ["account_id"], name: "index_wallets_on_account_id"
  end

  add_foreign_key "accounts", "users", on_delete: :cascade
  add_foreign_key "wallet_transactions", "wallets", column: "wallet_from", on_delete: :cascade
  add_foreign_key "wallet_transactions", "wallets", column: "wallet_to", on_delete: :cascade
  add_foreign_key "wallets", "accounts", on_delete: :cascade
end
