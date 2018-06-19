class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :cita_hash, null: false, index: { unique: true }
      t.text :content
      t.string :block_number
      t.string :block_hash
      t.string :index

      t.timestamps
    end

    add_reference :transactions, :block, index: true
  end
end
