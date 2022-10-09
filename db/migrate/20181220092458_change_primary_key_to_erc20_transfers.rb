class ChangePrimaryKeyToErc20Transfers < ActiveRecord::Migration[5.2]
  def up
    remove_column :erc20_transfers, :id
    execute "ALTER TABLE erc20_transfers ADD PRIMARY KEY (transaction_hash, transaction_log_index);"
  end

  def down
    execute "ALTER TABLE erc20_transfers DROP CONSTRAINT erc20_transfers_pkey;"
    add_column :erc20_transfers, :id, :primary_key
  end
end
