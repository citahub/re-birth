FactoryBot.define do
  factory :erc20_transfer do
    address { "0x0b9a7bad10e78aefbe6d99e61c7ea2a23c3ec888" }
    from { "0xac30bce77cf849d869aa37e39b983fa50767a2dd" }
    to { "0x6005ed6b942c99533b896b95fe8a90c7a7ecbf6a" }
    value { 10 }
    transaction_hash { "0x14b06be4067ba65d05e41d8821e2cf7d572a65b1bf53857a6a504ec42e69fdfd" }
    block_number { "0x18a1ec" }
    quota_used { "0x2d483" }

    association :tx, factory: :transaction
    association :event_log, factory: :erc20_event_log
  end
end
