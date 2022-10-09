class CreatePledgeTongbaos < ActiveRecord::Migration[5.2]
  def change
    create_table :pledge_tongbaos, primary_key: ["system_id", "pledge_id"] do |t|
      t.string :system_id, null: false
      t.string :pledge_id, null: false

      t.string :apply_enterprise_id
      t.text :aes_data
      t.jsonb :extra_data
      t.string :pledge_tb_id_list, array: true
      t.jsonb :amount_list
      t.string :receive_enterprise_id
      t.bigint :apply_time

      t.text :aes_cancel_data
      t.jsonb :extra_cancel_data
      t.bigint :cancel_time

      t.text :aes_accept_data
      t.jsonb :extra_accept_data
      t.boolean :is_adopt
      t.bigint :accept_time

      t.string :unlock_hold_ids, array: true

      t.timestamps

      t.index ["pledge_tb_id_list"], name: "pledge_tb_id_list", using: :gin
      t.index [:system_id, :is_adopt, :accept_time], name: "successed_pledge_tongbaos"
    end
  end
end
