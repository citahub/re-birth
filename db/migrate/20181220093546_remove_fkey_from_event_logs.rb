class RemoveFkeyFromEventLogs < ActiveRecord::Migration[5.2]
  def change
    remove_column :event_logs, :log_index_str
    remove_column :event_logs, :transaction_index_str
    remove_column :event_logs, :transaction_log_index_str
    remove_column :event_logs, :block_id
    remove_column :event_logs, :transaction_id

    add_index :event_logs, :block_hash
    add_index :event_logs, :transaction_hash
  end
end
