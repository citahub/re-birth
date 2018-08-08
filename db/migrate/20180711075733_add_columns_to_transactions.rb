class AddColumnsToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :from, :string
    add_column :transactions, :to, :string
    add_column :transactions, :data, :text
    add_column :transactions, :value, :string
    add_column :transactions, :contract_address, :string
    add_column :transactions, :gas_used, :string
  end
end
