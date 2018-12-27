class RemoveFkeyFromTransactions < ActiveRecord::Migration[5.2]
  def change
    remove_column :transactions, :block_id

    add_index :transactions, :block_hash
    add_index :transactions, :from
    add_index :transactions, :to
  end
end
