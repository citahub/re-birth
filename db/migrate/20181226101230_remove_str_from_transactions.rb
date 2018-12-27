class RemoveStrFromTransactions < ActiveRecord::Migration[5.2]
  def change
    remove_column :transactions, :block_number_str, :string
    remove_column :transactions, :index_str, :string
    remove_column :transactions, :value_str, :string
    remove_column :transactions, :quota_used_str, :string
  end
end
