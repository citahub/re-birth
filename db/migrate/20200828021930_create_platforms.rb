class CreatePlatforms < ActiveRecord::Migration[5.2]
  def change
    create_table :platforms, primary_key: "system_id", id: :string do |t|
      t.string :tb_manager
      t.string :rights_account
      t.decimal :rights_amount, precision: 80
      t.bigint :begin_push_block
      t.string :sm4_key
      t.string :sm4_iv
      t.string :push_admin_id

      t.timestamps
    end
  end
end
