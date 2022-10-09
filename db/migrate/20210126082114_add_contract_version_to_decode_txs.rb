class AddContractVersionToDecodeTxs < ActiveRecord::Migration[5.2]
  def change
    add_column :decode_transactions, :contract_version, :string
  end
end
