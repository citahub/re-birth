class CreateBlocks < ActiveRecord::Migration[5.2]
  def change
    create_table :blocks do |t|
      t.integer :version
      t.string :cita_hash, null: false, index: { unique: true }
      t.jsonb :header
      t.jsonb :body

      # save block number
      t.integer :block_number, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
