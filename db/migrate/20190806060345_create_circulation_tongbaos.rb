class CreateCirculationTongbaos < ActiveRecord::Migration[5.2]
  def change
    create_table :circulation_tongbaos, primary_key: ["system_id", "transfer_id"] do |t|
      t.string :system_id
      t.string :transfer_id
      t.text :aes_data
      t.jsonb :extra_data
      t.string :transfer_tb_id_list, array: true
      t.string :hold_transferee_tb_id_list, array: true
      t.jsonb :amount_list
      t.string :recevier_id
      t.bigint :apply_time

      t.text :aes_review_data
      t.jsonb :extra_review_data
      t.bigint :review_time
      t.boolean :is_adopt

      t.text :aes_cancel_data
      t.jsonb :extra_cancel_data
      t.bigint :cancel_time

      t.text :aes_receive_data
      t.jsonb :extra_receive_data
      t.bigint :receive_time
      t.boolean :is_receive

      t.bigint :freeze_time
      t.bigint :pre_freeze_time

      t.timestamps

      t.index ["transfer_tb_id_list"], name: "origin_hold_circulation", using: :gin
      t.index ["hold_transferee_tb_id_list"], name: "target_hold_circulation", using: :gin
    end
  end
end
