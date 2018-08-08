class AddTransactionCountToBlocks < ActiveRecord::Migration[5.2]
  def change
    add_column :blocks, :transaction_count, :integer
  end
end
