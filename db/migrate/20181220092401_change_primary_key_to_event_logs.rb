class ChangePrimaryKeyToEventLogs < ActiveRecord::Migration[5.2]
  def up
    remove_column :event_logs, :id
    execute "ALTER TABLE event_logs ADD PRIMARY KEY (transaction_hash, transaction_log_index);"
  end

  def down
    execute "ALTER TABLE event_logs DROP CONSTRAINT event_logs_pkey;"
    add_column :event_logs, :id, :primary_key
  end
end
