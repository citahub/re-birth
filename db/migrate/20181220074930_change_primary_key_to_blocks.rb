class ChangePrimaryKeyToBlocks < ActiveRecord::Migration[5.2]
  def up
    remove_column :blocks, :id
    execute "ALTER TABLE blocks ADD PRIMARY KEY (cita_hash);"
  end

  def down
    execute "ALTER TABLE blocks DROP CONSTRAINT blocks_pkey;"
    add_column :blocks, :id, :primary_key
  end
end
