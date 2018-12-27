class RemoveStrFromEventLogs < ActiveRecord::Migration[5.2]
  def change
    remove_column :event_logs, :block_number_str, :string
  end
end
