class CreateOpenTongbaos < ActiveRecord::Migration[5.2]
  def change
    create_table :open_tongbaos, primary_key: ["system_id", "tongbao_id"], force: :cascade do |t|
      t.string :system_id
      t.string :tongbao_id
      t.string :hold_transfer_tb_id
      t.text :aes_data
      t.jsonb :extra_data
      t.decimal :creditor_rights_amount, precision: 80
      t.string :apply_enterprise_id
      t.string :create_enterprise_id
      t.string :receive_enterprise_id
      t.bigint :payment_date
      t.bigint :apply_time
      t.boolean :is_quick

      t.bigint :platform_time
      t.text :aes_platform_data
      t.jsonb :extra_platform_data
      t.boolean :platform_agreed

      t.bigint :enterprise_time
      t.text :aes_enterprise_data
      t.jsonb :extra_enterprise_data
      t.boolean :enterprise_agreed

      t.bigint :receive_time, index: true
      t.text :aes_receive_data
      t.jsonb :extra_receive_data
      t.boolean :received

      t.bigint :cancel_time
      t.text :aes_cancel_data
      t.jsonb :extra_cancel_data

      t.bigint :back_creditor_time

      t.bigint :refuse_time
      t.text :aes_refuse_data
      t.jsonb :extra_refuse_data

      t.text :aes_pre_data
      t.jsonb :extra_pre_data
      t.string :pre_financing_ids, array: true
      t.string :pre_transfer_ids, array: true
      t.bigint :pre_time

      t.text :aes_redeem_data
      t.jsonb :extra_redeem_data
      t.bigint :redeem_time

      t.timestamps
    end
  end
end
