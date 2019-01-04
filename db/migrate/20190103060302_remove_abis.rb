class RemoveAbis < ActiveRecord::Migration[5.2]
  def change
    drop_table :abis
  end
end
