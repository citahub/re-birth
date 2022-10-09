class AddAuthInfoToPlatforms < ActiveRecord::Migration[5.2]
  def change
    add_column :platforms, :auth_address, :string
    add_column :platforms, :auth_private_key, :string
  end
end
