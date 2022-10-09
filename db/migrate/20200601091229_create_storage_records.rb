class CreateStorageRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :storage_records do |t|
      t.string :system_id
      t.string :tx_hash
      t.integer :block_number
      t.integer :tx_index
      t.string :token_id
      t.jsonb :data
      t.string :status, default: "pending" # pending sent_tx receive_tx
      t.integer :request_times, default: 0
      t.jsonb :tx_respond
      t.jsonb :tx_receipt
      t.bigint :invoke_time

      t.timestamps
    end
  end
end
