class CreateDecodeTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :decode_transactions, primary_key: "tx_hash", id: :string, force: :cascade do |t|
      t.jsonb "request_abi"
      t.jsonb "request_args"
      t.jsonb "decode_logs"
      t.string "contract_name"
      t.bigint "timestamp"
      t.bigint "block_number"
      t.integer "tx_index"

      t.timestamps

      t.index ["block_number", "tx_index"], name: "index_block_number_tx_index_on_decode_txs"
    end
  end
end
