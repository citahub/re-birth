class AddConractNameToErc20 < ActiveRecord::Migration[5.2]
  def change
    add_column :erc20_transfers, :contract_name, :string
  end
end
