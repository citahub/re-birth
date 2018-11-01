class AddVersionToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :version, :bigint, default: 0
    add_column :transactions, :chain_id, :jsonb

    reversible do |dir|
      dir.up do
        chain_id = SyncInfo.chain_id
        Transaction.update_all(chain_id: chain_id)
      end
    end
  end
end
