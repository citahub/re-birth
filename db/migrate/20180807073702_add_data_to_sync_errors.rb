class AddDataToSyncErrors < ActiveRecord::Migration[5.2]
  def change
    add_column :sync_errors, :data, :json
  end
end
