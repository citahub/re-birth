class CreateFreezeItems < ActiveRecord::Migration[5.2]
  def change
    create_table :freeze_items, primary_key: ["tx_hash", "log_index"], force: :cascade do |t|
      t.string :system_id
      t.string :open_tongbao_id
      t.string :hold_id
      t.decimal :amount, precision: 80
      t.boolean :is_freeze
      t.string :origin_function
      t.string :tx_hash, null: false
      t.integer :log_index, null: false
      t.bigint :block_number

      t.timestamps

      t.index ["system_id", "open_tongbao_id"], name: "index_system_open_tongbao_on_freeze_items"
      t.index ["system_id", "hold_id"], name: "index_system_hold_id_on_freeze_items"
    end
  end
end
