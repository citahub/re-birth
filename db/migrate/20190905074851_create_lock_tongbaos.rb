class CreateLockTongbaos < ActiveRecord::Migration[5.2]
  def change
    create_table :lock_tongbaos, primary_key: ["tx_hash", "log_index"] do |t|
      t.string :system_id
      t.string :tongbao_id
      t.decimal :lock_value, precision: 80
      t.string :to_ent_id
      t.string :timestamp
      t.boolean :is_lock
      t.string :origin_function
      t.string :business_id
      t.string :business_name
      t.string :tx_hash, null: false
      t.integer :log_index, null: false

      t.timestamps

      t.index ["system_id", "tongbao_id"], name: "index_system_tongbao_id_on_lock_tongbaos"
    end
  end
end
