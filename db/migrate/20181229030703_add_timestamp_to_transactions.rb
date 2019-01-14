class AddTimestampToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :timestamp, :bigint

    reversible do |dir|
      dir.up do
        execute %{UPDATE transactions AS tx SET "timestamp" = subquery.timestamp FROM (SELECT block_hash, "timestamp" FROM blocks AS b) AS subquery WHERE tx.block_hash = subquery.block_hash;}
      end
    end
  end
end
