class RemoveFkeyFromErc20Transfers < ActiveRecord::Migration[5.2]
  def change
    remove_column :erc20_transfers, :block_id
    remove_column :erc20_transfers, :transaction_id
    remove_column :erc20_transfers, :event_log_id
  end
end
