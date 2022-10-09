class CreateOperators < ActiveRecord::Migration[5.2]
  def change
    create_table :operators, primary_key: ["system_id", "address"] do |t|
      t.string :system_id
      t.string :address
      t.text :aes_data
      t.jsonb :extra_data
      t.string :institutions_id
      t.boolean :is_active
      t.string :operator_id

      t.timestamps
    end
  end
end
