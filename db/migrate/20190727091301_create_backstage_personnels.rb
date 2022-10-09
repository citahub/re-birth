class CreateBackstagePersonnels < ActiveRecord::Migration[5.2]
  def change
    create_table :backstage_personnels, primary_key: ["system_id", "address"] do |t|
      t.string :system_id
      t.string :address
      t.text :aes_data
      t.jsonb :extra_data
      t.integer :operator_type
      t.boolean :is_active
      t.timestamps
    end
  end
end
