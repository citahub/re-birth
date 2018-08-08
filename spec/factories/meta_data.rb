FactoryBot.define do
  factory :meta_data, class: MetaData do
    chain_id 1
    chain_name "test-chain"
    operator "test-operator"
    genesis_timestamp 1530164125967
    validators([
                 "0x365d339609728590ec0803a73b95c24fde718846",
                 "0xf1551b918a4f43c1b72d322b8f91d4caebc249de",
                 "0x6e66c49ed7cf07754cd5794a43d41704b7c1e217",
                 "0xb4061fa8e18654a7d51fef3866d45bb1dc688717"
               ])
    block_interval 3000
    token_symbol "NOS"
    token_avatar "https://avatars1.githubusercontent.com/u/35361817"
    token_name nil
    website "https://www.example.com"
    block_number 0

    association :block, factory: :block_zero
  end
end
