class CreateSyncErrors < ActiveRecord::Migration[5.2]
  def change
    create_table :sync_errors do |t|
      t.string :method
      # array should be same type
      t.json :params
      t.integer :code
      t.string :message

      t.timestamps
    end
  end
end
