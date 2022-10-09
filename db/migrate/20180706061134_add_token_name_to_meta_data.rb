class AddTokenNameToMetaData < ActiveRecord::Migration[5.2]
  def change
    add_column :meta_data, :token_name, :string
  end
end
