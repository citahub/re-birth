class ChangeNumTypesToErc20Transfers < ActiveRecord::Migration[5.2]
  def change
    rename_column :erc20_transfers, :block_number, :block_number_str
    rename_column :erc20_transfers, :quota_used, :quota_used_str

    add_column :erc20_transfers, :block_number, :integer, index: true
    add_column :erc20_transfers, :quota_used, :decimal, precision: 100

    reversible do |dir|
      dir.up do
        # TODO: Have no idea to cast quota_used_str to quota_used by PostgreSQL
        Erc20Transfer.find_each do |transfer|
          transfer.update!(block_number: transfer.block_number_str&.hex, quota_used: transfer.quota_used_str&.hex)
        end
      end
    end
  end
end
