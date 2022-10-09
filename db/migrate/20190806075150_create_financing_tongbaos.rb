class CreateFinancingTongbaos < ActiveRecord::Migration[5.2]
  def change
    create_table :financing_tongbaos, primary_key: ["system_id", "financing_id"] do |t|
      t.string :system_id
      t.string :financing_id
      t.text :aes_data
      t.jsonb :extra_data
      t.decimal :financing_amount, precision: 80
      t.string :creditors_financing_id
      t.string :hold_transfer_tb_id_list, array: true
      t.string :split_hold_transfer_tb_id_list, array: true
      t.jsonb :amount_list
      t.string :apply_financing_id
      t.bigint :apply_time

      t.text :aes_platform_data
      t.jsonb :extra_platform_data
      t.bigint :platform_time
      t.boolean :platform_agreed

      t.text :aes_accept_data
      t.jsonb :extra_accept_data
      t.boolean :accept_agreed
      t.bigint :accept_time

      t.text :aes_cancel_data
      t.jsonb :extra_cancel_data
      t.bigint :cancel_time

      t.text :aes_supplement_data
      t.jsonb :extra_supplement_data
      t.bigint :supplement_time

      t.bigint :freeze_time
      t.bigint :pre_freeze_time

      t.timestamps

      t.index ["hold_transfer_tb_id_list"], name: "origin_hold_financing", using: :gin
      t.index ["split_hold_transfer_tb_id_list"], name: "target_hold_financing", using: :gin
    end
  end
end
