class CreateEventLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :event_logs do |t|
      t.string :address, index: true
      t.string :block_hash
      t.string :block_number
      t.text :data
      t.string :log_index
      t.string :topics, array: true
      t.string :transaction_hash
      t.string :transaction_index
      t.string :transaction_log_index

      t.timestamps
    end

    add_index :event_logs, :topics, using: :gin
  end
end
