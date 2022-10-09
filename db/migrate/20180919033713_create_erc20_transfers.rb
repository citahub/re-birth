class CreateErc20Transfers < ActiveRecord::Migration[5.2]
  def change
    create_table :erc20_transfers do |t|
      t.string :address, index: true
      t.string :from, index: true
      t.string :to, index: true
      t.decimal :value, precision: 260
      t.string :transaction_hash
      t.bigint :timestamp
      t.string :block_number
      t.string :gas_used

      t.timestamps
    end

    add_reference :erc20_transfers, :event_log, index: true
    add_reference :erc20_transfers, :transaction, index: true
    add_reference :erc20_transfers, :block, index: true
  end
end
