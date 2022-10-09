class RenameQuotaUsedToTransactions < ActiveRecord::Migration[5.2]
  def change
    rename_column :transactions, :gas_used, :quota_used
    rename_column :erc20_transfers, :gas_used, :quota_used
  end
end
