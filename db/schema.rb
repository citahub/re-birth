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

ActiveRecord::Schema.define(version: 2021_03_22_062003) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "backstage_personnels", primary_key: ["system_id", "address"], force: :cascade do |t|
    t.string "system_id", null: false
    t.string "address", null: false
    t.text "aes_data"
    t.jsonb "extra_data"
    t.integer "operator_type"
    t.boolean "is_active"
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

  create_table "circulation_tongbaos", primary_key: ["system_id", "transfer_id"], force: :cascade do |t|
    t.string "system_id", null: false
    t.string "transfer_id", null: false
    t.text "aes_data"
    t.jsonb "extra_data"
    t.string "transfer_tb_id_list", array: true
    t.string "hold_transferee_tb_id_list", array: true
    t.jsonb "amount_list"
    t.string "recevier_id"
    t.bigint "apply_time"
    t.text "aes_review_data"
    t.jsonb "extra_review_data"
    t.bigint "review_time"
    t.boolean "is_adopt"
    t.text "aes_cancel_data"
    t.jsonb "extra_cancel_data"
    t.bigint "cancel_time"
    t.text "aes_receive_data"
    t.jsonb "extra_receive_data"
    t.bigint "receive_time"
    t.boolean "is_receive"
    t.bigint "freeze_time"
    t.bigint "pre_freeze_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hold_transferee_tb_id_list"], name: "target_hold_circulation", using: :gin
    t.index ["transfer_tb_id_list"], name: "origin_hold_circulation", using: :gin
  end

  create_table "contract_abis", primary_key: "address", id: :string, force: :cascade do |t|
    t.string "contract_name"
    t.string "contract_version"
    t.bigint "block_number"
    t.jsonb "abi"
    t.boolean "is_static"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["block_number"], name: "index_contract_abis_on_block_number"
    t.index ["contract_name", "is_static", "block_number"], name: "index_name_static_timestamp_on_contract_abis"
  end

  create_table "decode_transactions", primary_key: "tx_hash", id: :string, force: :cascade do |t|
    t.jsonb "request_abi"
    t.jsonb "request_args"
    t.jsonb "decode_logs"
    t.string "contract_name"
    t.bigint "timestamp"
    t.bigint "block_number"
    t.integer "tx_index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "contract_version"
    t.index ["block_number", "tx_index"], name: "index_block_number_tx_index_on_decode_txs"
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
    t.string "contract_name"
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

  create_table "financing_tongbaos", primary_key: ["system_id", "financing_id"], force: :cascade do |t|
    t.string "system_id", null: false
    t.string "financing_id", null: false
    t.text "aes_data"
    t.jsonb "extra_data"
    t.decimal "financing_amount", precision: 80
    t.string "creditors_financing_id"
    t.string "hold_transfer_tb_id_list", array: true
    t.string "split_hold_transfer_tb_id_list", array: true
    t.jsonb "amount_list"
    t.string "apply_financing_id"
    t.bigint "apply_time"
    t.text "aes_platform_data"
    t.jsonb "extra_platform_data"
    t.bigint "platform_time"
    t.boolean "platform_agreed"
    t.text "aes_accept_data"
    t.jsonb "extra_accept_data"
    t.boolean "accept_agreed"
    t.bigint "accept_time"
    t.text "aes_cancel_data"
    t.jsonb "extra_cancel_data"
    t.bigint "cancel_time"
    t.text "aes_supplement_data"
    t.jsonb "extra_supplement_data"
    t.bigint "supplement_time"
    t.bigint "freeze_time"
    t.bigint "pre_freeze_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hold_transfer_tb_id_list"], name: "origin_hold_financing", using: :gin
    t.index ["split_hold_transfer_tb_id_list"], name: "target_hold_financing", using: :gin
  end

  create_table "freeze_items", primary_key: ["tx_hash", "log_index"], force: :cascade do |t|
    t.string "system_id"
    t.string "open_tongbao_id"
    t.string "hold_id"
    t.decimal "amount", precision: 80
    t.boolean "is_freeze"
    t.string "origin_function"
    t.string "tx_hash", null: false
    t.integer "log_index", null: false
    t.bigint "block_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["system_id", "hold_id"], name: "index_system_hold_id_on_freeze_items"
    t.index ["system_id", "open_tongbao_id"], name: "index_system_open_tongbao_on_freeze_items"
  end

  create_table "freeze_tongbaos", primary_key: ["tx_hash", "log_index"], force: :cascade do |t|
    t.string "system_id"
    t.string "tongbao_id"
    t.string "tx_hash", null: false
    t.integer "log_index", null: false
    t.text "aes_data"
    t.jsonb "extra_data"
    t.string "transfer_ids", array: true
    t.string "financing_ids", array: true
    t.boolean "is_freeze"
    t.bigint "timestamp"
    t.bigint "block_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["system_id", "tongbao_id"], name: "index_system_tongbao_id_on_freeze_tongbaos"
  end

  create_table "institutions", primary_key: ["system_id", "institutions_id"], force: :cascade do |t|
    t.string "system_id", null: false
    t.string "institutions_id", null: false
    t.text "aes_data"
    t.jsonb "extra_data"
    t.string "parent_ent_id"
    t.string "financial_code"
    t.integer "is_independent"
    t.integer "is_core_enterprise"
    t.text "credit_aes_data"
    t.jsonb "credit_extra_data"
    t.integer "credit_type"
    t.decimal "credit_limit", precision: 80
    t.bigint "credit_start_time"
    t.bigint "credit_end_time"
    t.decimal "lock_credit", precision: 80
    t.text "freeze_aes_data"
    t.jsonb "freeze_extra_data"
    t.boolean "freeze_type"
    t.decimal "credit_balance", precision: 80
    t.decimal "credit_spent", precision: 80
    t.decimal "credit_arrears", precision: 80
    t.bigint "credit_block_number"
    t.integer "credit_tx_index"
    t.string "ent_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "open_limit", precision: 80
    t.index ["credit_balance"], name: "index_institutions_on_credit_balance"
  end

  create_table "lock_credits", primary_key: ["tx_hash", "log_index"], force: :cascade do |t|
    t.string "system_id"
    t.decimal "rights_lock_limit", precision: 80
    t.integer "lock_type"
    t.string "institutions_id"
    t.string "open_tongbao_id"
    t.string "origin_function"
    t.bigint "timestamp"
    t.string "tx_hash", null: false
    t.integer "log_index", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["system_id", "institutions_id", "lock_type"], name: "index_ent_address_lock_type_on_lock_credits"
  end

  create_table "lock_tongbaos", primary_key: ["tx_hash", "log_index"], force: :cascade do |t|
    t.string "system_id"
    t.string "tongbao_id"
    t.decimal "lock_value", precision: 80
    t.string "to_ent_id"
    t.string "timestamp"
    t.boolean "is_lock"
    t.string "origin_function"
    t.string "business_id"
    t.string "business_name"
    t.string "tx_hash", null: false
    t.integer "log_index", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["system_id", "tongbao_id"], name: "index_system_tongbao_id_on_lock_tongbaos"
  end

  create_table "open_tongbaos", primary_key: ["system_id", "tongbao_id"], force: :cascade do |t|
    t.string "system_id", null: false
    t.string "tongbao_id", null: false
    t.string "hold_transfer_tb_id"
    t.text "aes_data"
    t.jsonb "extra_data"
    t.decimal "creditor_rights_amount", precision: 80
    t.string "apply_enterprise_id"
    t.string "create_enterprise_id"
    t.string "receive_enterprise_id"
    t.bigint "payment_date"
    t.bigint "apply_time"
    t.boolean "is_quick"
    t.bigint "platform_time"
    t.text "aes_platform_data"
    t.jsonb "extra_platform_data"
    t.boolean "platform_agreed"
    t.bigint "enterprise_time"
    t.text "aes_enterprise_data"
    t.jsonb "extra_enterprise_data"
    t.boolean "enterprise_agreed"
    t.bigint "receive_time"
    t.text "aes_receive_data"
    t.jsonb "extra_receive_data"
    t.boolean "received"
    t.bigint "cancel_time"
    t.text "aes_cancel_data"
    t.jsonb "extra_cancel_data"
    t.bigint "back_creditor_time"
    t.bigint "refuse_time"
    t.text "aes_refuse_data"
    t.jsonb "extra_refuse_data"
    t.text "aes_pre_data"
    t.jsonb "extra_pre_data"
    t.string "pre_financing_ids", array: true
    t.string "pre_transfer_ids", array: true
    t.bigint "pre_time"
    t.text "aes_redeem_data"
    t.jsonb "extra_redeem_data"
    t.bigint "redeem_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invoice_encrypted", array: true
    t.jsonb "invoice_decrypted"
    t.boolean "is_advance_charge"
    t.index ["receive_time"], name: "index_open_tongbaos_on_receive_time"
  end

  create_table "operators", primary_key: ["system_id", "address"], force: :cascade do |t|
    t.string "system_id", null: false
    t.string "address", null: false
    t.text "aes_data"
    t.jsonb "extra_data"
    t.string "institutions_id"
    t.boolean "is_active"
    t.string "operator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "platforms", primary_key: "system_id", id: :string, force: :cascade do |t|
    t.string "tb_manager"
    t.string "rights_account"
    t.decimal "rights_amount", precision: 80
    t.bigint "begin_push_block"
    t.string "sm4_key"
    t.string "sm4_iv"
    t.string "push_admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auth_address"
    t.string "auth_private_key"
  end

  create_table "pledge_tongbaos", primary_key: ["system_id", "pledge_id"], force: :cascade do |t|
    t.string "system_id", null: false
    t.string "pledge_id", null: false
    t.string "apply_enterprise_id"
    t.text "aes_data"
    t.jsonb "extra_data"
    t.string "pledge_tb_id_list", array: true
    t.jsonb "amount_list"
    t.string "receive_enterprise_id"
    t.bigint "apply_time"
    t.text "aes_cancel_data"
    t.jsonb "extra_cancel_data"
    t.bigint "cancel_time"
    t.text "aes_accept_data"
    t.jsonb "extra_accept_data"
    t.boolean "is_adopt"
    t.bigint "accept_time"
    t.string "unlock_hold_ids", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pledge_tb_id_list"], name: "pledge_tb_id_list", using: :gin
    t.index ["system_id", "is_adopt", "accept_time"], name: "successed_pledge_tongbaos"
  end

  create_table "storage_records", force: :cascade do |t|
    t.string "system_id"
    t.string "tx_hash"
    t.integer "block_number"
    t.integer "tx_index"
    t.string "token_id"
    t.jsonb "data"
    t.string "status", default: "pending"
    t.integer "request_times", default: 0
    t.jsonb "tx_respond"
    t.jsonb "tx_receipt"
    t.bigint "invoke_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "store_index"
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

  create_table "tongbaos", primary_key: ["system_id", "hold_id"], force: :cascade do |t|
    t.string "system_id", null: false
    t.string "hold_id", null: false
    t.string "tongbao_id"
    t.string "from_hold_id"
    t.string "from_ent_id"
    t.string "hold_ent_id"
    t.decimal "amount", precision: 80
    t.bigint "timestamp"
    t.string "transfer_type"
    t.bigint "pre_redeem_time"
    t.bigint "redeem_time"
    t.decimal "redeem_amount", precision: 80
    t.decimal "balance", precision: 80
    t.string "transfer_no"
    t.decimal "lock_amount", precision: 80
    t.bigint "freeze_block_number"
    t.bigint "unfreeze_block_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hold_ent_id"], name: "index_tongbaos_on_hold_ent_id"
    t.index ["lock_amount"], name: "index_tongbaos_on_lock_amount"
    t.index ["redeem_time"], name: "index_tongbaos_on_redeem_time"
    t.index ["timestamp", "transfer_type"], name: "index_tongbaos_on_timestamp_type"
    t.index ["tongbao_id"], name: "index_tongbaos_on_tongbao_id"
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
