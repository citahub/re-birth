class CreateTongbaos < ActiveRecord::Migration[5.2]
  def change
    create_table :tongbaos, primary_key: ["system_id", "hold_id"] do |t|
      t.string :system_id
      t.string :hold_id
      t.string :tongbao_id, index: true
      t.string :from_hold_id
      t.string :from_ent_id
      t.string :hold_ent_id, index: true
      t.decimal :amount, precision: 80
      t.bigint :timestamp
      t.string :transfer_type

      t.bigint :pre_redeem_time
      t.bigint :redeem_time, index: true
      t.decimal :redeem_amount, precision: 80

      t.decimal :balance, precision: 80

      t.string :transfer_no

      t.decimal :lock_amount, precision: 80, index: true

      t.bigint :freeze_block_number
      t.bigint :unfreeze_block_number

      t.timestamps

      t.index ["timestamp", "transfer_type"], name: "index_tongbaos_on_timestamp_type"
    end
  end
end
