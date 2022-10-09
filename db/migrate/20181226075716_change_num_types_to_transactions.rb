class ChangeNumTypesToTransactions < ActiveRecord::Migration[5.2]
  def change
    rename_column :transactions, :block_number, :block_number_str
    rename_column :transactions, :index, :index_str
    rename_column :transactions, :value, :value_str
    rename_column :transactions, :quota_used, :quota_used_str

    add_column :transactions, :block_number, :integer, index: true
    add_column :transactions, :index, :integer, index: true
    add_column :transactions, :value, :decimal, precision: 100
    add_column :transactions, :quota_used, :decimal, precision: 100

    reversible do |dir|
      dir.up do
        # TODO: Have no idea for cast value_str to value by PostgreSQL now.
        Transaction.find_each do |tx|
          tx.update(value: tx.value_str&.hex, block_number: tx.block_number_str&.hex, index: tx.index_str&.hex, quota_used: tx.quota_used_str&.hex)
        end
      end
    end
  end
end
