class CreateInstitutions < ActiveRecord::Migration[5.2]
  def change
    create_table :institutions, primary_key: ["system_id", "institutions_id"] do |t|
      t.string :system_id
      t.string :institutions_id
      t.text :aes_data
      t.jsonb :extra_data
      t.string :parent_ent_id
      t.string :financial_code
      t.integer :is_independent
      t.integer :is_core_enterprise

      t.text :credit_aes_data
      t.jsonb :credit_extra_data
      t.integer :credit_type
      t.decimal :credit_limit, precision: 80
      t.bigint :credit_start_time
      t.bigint :credit_end_time
      t.decimal :lock_credit,  precision: 80

      t.text  :freeze_aes_data
      t.jsonb :freeze_extra_data
      t.boolean :freeze_type

      t.decimal :credit_balance,  precision: 80
      t.decimal :credit_spent,  precision: 80
      t.decimal :credit_arrears,  precision: 80
      t.bigint :credit_block_number
      t.integer :credit_tx_index

      t.string :ent_name

      t.timestamps
    end
  end
end
