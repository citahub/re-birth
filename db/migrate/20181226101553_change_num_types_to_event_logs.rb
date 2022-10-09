class ChangeNumTypesToEventLogs < ActiveRecord::Migration[5.2]
  def change
    rename_column :event_logs, :block_number, :block_number_str

    add_column :event_logs, :block_number, :integer, index: true

    reversible do |dir|
      dir.up do
        execute "UPDATE event_logs SET block_number = subquery.block_number_num FROM (SELECT ('x'||lpad(substr(block_number_str, 3, char_length(block_number_str)), 16, '0'))::bit(64)::bigint::int AS block_number_num, transaction_hash, transaction_log_index FROM event_logs) AS subquery WHERE event_logs.transaction_hash = subquery.transaction_hash AND event_logs.transaction_log_index = subquery.transaction_log_index;"
      end
    end
  end
end
