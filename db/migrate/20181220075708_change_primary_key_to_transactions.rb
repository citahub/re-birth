class ChangePrimaryKeyToTransactions < ActiveRecord::Migration[5.2]
  def up
    remove_column :transactions, :id
    execute "ALTER TABLE transactions ADD PRIMARY KEY (cita_hash);"
  end

  def down
    execute "ALTER TABLE transactions DROP CONSTRAINT transactions_pkey;"
    add_column :transactions, :id, :primary_key
  end
end
