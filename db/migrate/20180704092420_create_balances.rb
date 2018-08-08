class CreateBalances < ActiveRecord::Migration[5.2]
  def change
    create_table :balances do |t|
      t.string :address
      t.integer :height
      t.string :value

      t.timestamps
    end
  end
end
