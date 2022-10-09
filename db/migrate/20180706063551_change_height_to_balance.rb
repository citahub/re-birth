class ChangeHeightToBalance < ActiveRecord::Migration[5.2]
  def change
    rename_column :balances, :height, :block_number
  end
end
