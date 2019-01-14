class RemoveStrFromErc20Transfers < ActiveRecord::Migration[5.2]
  def change
    remove_column :erc20_transfers, :block_number_str, :string
    remove_column :erc20_transfers, :quota_used_str, :string
  end
end
