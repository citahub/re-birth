class CreateMetaData < ActiveRecord::Migration[5.2]
  def change
    create_table :meta_data do |t|
      t.integer :chain_id
      t.string :chain_name
      t.string :operator
      t.bigint :genesis_timestamp
      t.string :validators, array: true
      t.integer :block_interval
      t.string :token_symbol
      t.string :token_avatar
      t.string :website

      # the number of block
      t.integer :block_number

      t.timestamps
    end

    add_reference :meta_data, :block, index: true
  end
end
