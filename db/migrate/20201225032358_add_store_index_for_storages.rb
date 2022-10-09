class AddStoreIndexForStorages < ActiveRecord::Migration[5.2]
  def change
    add_column :storage_records, :store_index, :string
  end
end
