class DropMetaData < ActiveRecord::Migration[5.2]
  def change
    drop_table :meta_data
  end
end
