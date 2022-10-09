class CreateContractAbis < ActiveRecord::Migration[5.2]
  def change
    create_table :contract_abis, primary_key: "address", id: :string, force: :cascade do |t|
      t.string :contract_name
      t.string :contract_version
      t.bigint :block_number, index: true
      t.jsonb :abi
      t.boolean :is_static
      t.timestamps

      t.index ["contract_name", "is_static", "block_number"], name: "index_name_static_timestamp_on_contract_abis"
    end
  end
end
