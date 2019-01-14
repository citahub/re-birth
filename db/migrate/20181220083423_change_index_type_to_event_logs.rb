class ChangeIndexTypeToEventLogs < ActiveRecord::Migration[5.2]
  def change
    rename_column :event_logs, :transaction_index, :transaction_index_str
    rename_column :event_logs, :log_index, :log_index_str
    rename_column :event_logs, :transaction_log_index, :transaction_log_index_str

    add_column :event_logs, :transaction_index, :integer, index: true
    add_column :event_logs, :log_index, :integer, index: true
    add_column :event_logs, :transaction_log_index, :integer, index: true

    reversible do |dir|
      dir.up do
        execute "UPDATE event_logs SET log_index = subquery.log_index_num, transaction_index = subquery.tx_index_num, transaction_log_index = subquery.transaction_log_index_num FROM (SELECT ('x'||lpad(substr(log_index_str, 3, char_length(log_index_str)), 16, '0'))::bit(64)::bigint::int AS log_index_num, ('x'||lpad(substr(transaction_index_str, 3, char_length(transaction_index_str)), 16, '0'))::bit(64)::bigint::int AS tx_index_num, ('x'||lpad(substr(transaction_log_index_str, 3, char_length(transaction_log_index_str)), 16, '0'))::bit(64)::bigint::int AS transaction_log_index_num, id FROM event_logs) AS subquery WHERE event_logs.id = subquery.id;"
      end
    end

  end
end
