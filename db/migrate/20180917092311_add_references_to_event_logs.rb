class AddReferencesToEventLogs < ActiveRecord::Migration[5.2]
  def change
    add_reference :event_logs, :transaction, index: true
    add_reference :event_logs, :block, index: true
  end
end
