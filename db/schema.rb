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

ActiveRecord::Schema.define(version: 2018_12_29_030703) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abis", force: :cascade do |t|
    t.string "address"
    t.integer "block_number"
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "balances", force: :cascade do |t|
    t.string "address"
    t.integer "block_number"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "blocks", primary_key: "block_hash", id: :string, force: :cascade do |t|
    t.integer "version"
    t.jsonb "header"
    t.jsonb "body"
    t.integer "block_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "transaction_count"
    t.bigint "timestamp"
    t.string "proposer"
    t.decimal "quota_used", precision: 100
    t.index ["block_hash"], name: "index_blocks_on_block_hash", unique: true
    t.index ["block_number"], name: "index_blocks_on_block_number", unique: true
    t.index ["body"], name: "index_blocks_on_body", using: :gin
    t.index ["header"], name: "index_blocks_on_header", using: :gin
  end

  create_table "erc20_transfers", primary_key: ["transaction_hash", "transaction_log_index"], force: :cascade do |t|
    t.string "address"
    t.string "from"
    t.string "to"
    t.decimal "value", precision: 260
    t.string "transaction_hash", null: false
    t.bigint "timestamp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "block_hash"
    t.integer "log_index"
    t.integer "transaction_log_index", null: false
    t.integer "block_number"
    t.decimal "quota_used", precision: 100
    t.index ["address"], name: "index_erc20_transfers_on_address"
    t.index ["from"], name: "index_erc20_transfers_on_from"
    t.index ["to"], name: "index_erc20_transfers_on_to"
  end

  create_table "event_logs", primary_key: ["transaction_hash", "transaction_log_index"], force: :cascade do |t|
    t.string "address"
    t.string "block_hash"
    t.text "data"
    t.string "topics", array: true
    t.string "transaction_hash", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "transaction_index"
    t.integer "log_index"
    t.integer "transaction_log_index", null: false
    t.integer "block_number"
    t.index ["address"], name: "index_event_logs_on_address"
    t.index ["block_hash"], name: "index_event_logs_on_block_hash"
    t.index ["topics"], name: "index_event_logs_on_topics", using: :gin
    t.index ["transaction_hash"], name: "index_event_logs_on_transaction_hash"
  end

  create_table "sync_errors", force: :cascade do |t|
    t.string "method"
    t.json "params"
    t.integer "code"
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "data"
  end

  create_table "sync_infos", force: :cascade do |t|
    t.string "name"
    t.jsonb "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_sync_infos_on_name"
  end

  create_table "transactions", primary_key: "tx_hash", id: :string, force: :cascade do |t|
    t.text "content"
    t.string "block_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "from"
    t.string "to"
    t.text "data"
    t.string "contract_address"
    t.string "error_message"
    t.bigint "version", default: 0
    t.jsonb "chain_id"
    t.integer "block_number"
    t.integer "index"
    t.decimal "value", precision: 100
    t.decimal "quota_used", precision: 100
    t.bigint "timestamp"
    t.index ["block_hash"], name: "index_transactions_on_block_hash"
    t.index ["from"], name: "index_transactions_on_from"
    t.index ["to"], name: "index_transactions_on_to"
    t.index ["tx_hash"], name: "index_transactions_on_tx_hash", unique: true
  end

  create_table "validator_caches", force: :cascade do |t|
    t.string "name", null: false
    t.integer "counter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_validator_caches_on_name", unique: true
  end

end
