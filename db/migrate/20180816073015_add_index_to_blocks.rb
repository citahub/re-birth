class AddIndexToBlocks < ActiveRecord::Migration[5.2]
  def change
    add_index :blocks, :header, using: :gin
    add_index :blocks, :body, using: :gin
  end
end
