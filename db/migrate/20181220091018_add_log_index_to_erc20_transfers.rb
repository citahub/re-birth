class AddLogIndexToErc20Transfers < ActiveRecord::Migration[5.2]
  def change
    add_column :erc20_transfers, :log_index, :integer, index: true
    add_column :erc20_transfers, :transaction_log_index, :integer, index: true

    reversible do |dir|
      dir.up do
        execute "UPDATE erc20_transfers SET log_index = subquery.log_index, transaction_log_index = subquery.transaction_log_index FROM (SELECT id, log_index, transaction_log_index from event_logs) AS subquery WHERE erc20_transfers.event_log_id = subquery.id;"
      end
    end

  end
end
