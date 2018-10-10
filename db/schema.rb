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

ActiveRecord::Schema.define(version: 2018_10_09_022937) do

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

  create_table "blocks", force: :cascade do |t|
    t.integer "version"
    t.string "cita_hash", null: false
    t.jsonb "header"
    t.jsonb "body"
    t.integer "block_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "transaction_count"
    t.index ["block_number"], name: "index_blocks_on_block_number", unique: true
    t.index ["body"], name: "index_blocks_on_body", using: :gin
    t.index ["cita_hash"], name: "index_blocks_on_cita_hash", unique: true
    t.index ["header"], name: "index_blocks_on_header", using: :gin
  end

  create_table "erc20_transfers", force: :cascade do |t|
    t.string "address"
    t.string "from"
    t.string "to"
    t.decimal "value", precision: 260
    t.string "transaction_hash"
    t.bigint "timestamp"
    t.string "block_number"
    t.string "gas_used"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "event_log_id"
    t.bigint "transaction_id"
    t.bigint "block_id"
    t.index ["address"], name: "index_erc20_transfers_on_address"
    t.index ["block_id"], name: "index_erc20_transfers_on_block_id"
    t.index ["event_log_id"], name: "index_erc20_transfers_on_event_log_id"
    t.index ["from"], name: "index_erc20_transfers_on_from"
    t.index ["to"], name: "index_erc20_transfers_on_to"
    t.index ["transaction_id"], name: "index_erc20_transfers_on_transaction_id"
  end

  create_table "event_logs", force: :cascade do |t|
    t.string "address"
    t.string "block_hash"
    t.string "block_number"
    t.text "data"
    t.string "log_index"
    t.string "topics", array: true
    t.string "transaction_hash"
    t.string "transaction_index"
    t.string "transaction_log_index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "transaction_id"
    t.bigint "block_id"
    t.index ["address"], name: "index_event_logs_on_address"
    t.index ["block_id"], name: "index_event_logs_on_block_id"
    t.index ["topics"], name: "index_event_logs_on_topics", using: :gin
    t.index ["transaction_id"], name: "index_event_logs_on_transaction_id"
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

  create_table "transactions", force: :cascade do |t|
    t.string "cita_hash", null: false
    t.text "content"
    t.string "block_number"
    t.string "block_hash"
    t.string "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "block_id"
    t.string "from"
    t.string "to"
    t.text "data"
    t.string "value"
    t.string "contract_address"
    t.string "gas_used"
    t.string "error_message"
    t.index ["block_id"], name: "index_transactions_on_block_id"
    t.index ["cita_hash"], name: "index_transactions_on_cita_hash", unique: true
  end

  create_table "validator_caches", force: :cascade do |t|
    t.string "name", null: false
    t.integer "counter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_validator_caches_on_name", unique: true
  end

end
