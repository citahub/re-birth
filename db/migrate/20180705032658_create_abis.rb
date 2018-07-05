class CreateAbis < ActiveRecord::Migration[5.2]
  def change
    create_table :abis do |t|
      t.string :address
      t.integer :block_number
      t.text :value

      t.timestamps
    end
  end
end
