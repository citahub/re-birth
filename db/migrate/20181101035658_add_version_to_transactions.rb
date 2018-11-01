class AddVersionToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :version, :bigint, default: 0
    add_column :transactions, :chain_id, :jsonb
  end
end
