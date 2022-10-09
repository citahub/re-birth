class CreateLockCredits < ActiveRecord::Migration[5.2]
  def change
    create_table :lock_credits, primary_key: ["tx_hash", "log_index"] do |t|
      t.string :system_id
      t.decimal :rights_lock_limit, precision: 80
      t.integer :lock_type
      t.string :institutions_id
      t.string :open_tongbao_id
      t.string :origin_function
      t.bigint :timestamp
      t.string :tx_hash, null: false
      t.integer :log_index, null: false

      t.timestamps

      t.index [:system_id, :institutions_id, :lock_type], name: "index_ent_address_lock_type_on_lock_credits"
    end
  end
end
