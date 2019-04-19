class AddTxCountIndexToBlocks < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!
  def change
    add_index :blocks, [:block_number, :transaction_count], algorithm: :concurrently
  end
end
