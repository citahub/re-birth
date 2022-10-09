class CreateFreezeTongbaos < ActiveRecord::Migration[5.2]
  def change
    create_table :freeze_tongbaos, primary_key: ["tx_hash", "log_index"] do |t|
      t.string :system_id
      t.string :tongbao_id
      t.string :tx_hash, null: false
      t.integer :log_index, null: false
      t.text :aes_data
      t.jsonb :extra_data
      t.string :transfer_ids, array: true
      t.string :financing_ids, array: true
      t.boolean :is_freeze
      t.bigint :timestamp
      t.bigint :block_number

      t.timestamps

      t.index ["system_id", "tongbao_id"], name: "index_system_tongbao_id_on_freeze_tongbaos"
    end
  end
end
