class AddBlockHashToErc20Transfers < ActiveRecord::Migration[5.2]
  def change
    add_column :erc20_transfers, :block_hash, :string, index: true

    reversible do |dir|
      dir.up do
        sql = "UPDATE erc20_transfers SET block_hash = subquery.block_hash FROM (SELECT block_number, block_hash FROM event_logs) AS subquery WHERE erc20_transfers.block_number = subquery.block_number"
        execute sql
      end
    end

  end
end
