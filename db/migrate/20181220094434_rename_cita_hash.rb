class RenameCitaHash < ActiveRecord::Migration[5.2]
  def change
    rename_column :blocks, :cita_hash, :block_hash
    rename_column :transactions, :cita_hash, :tx_hash
  end
end
