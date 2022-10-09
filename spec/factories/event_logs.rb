FactoryBot.define do
  factory :event_log do
    address { "0x35bd452c37d28beca42097cfd8ba671c8dd430a1" }
    block_hash { "0x2bb2dab1bc4e332ca61fe15febf06a1fd09738d6304d76c5dd9b57cb46880e28" }
    block_number { "0xf11e2" }
    data { "0x00000000000000000000000046a23e25df9a0f6c18729dda9ad1af3b6a1311600000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000001c68656c6c6f20776f726c64206174203135333534343433343437363700000000" }
    log_index { "0x0" }
    topics { [
             "0xe4af93ca7e370881e6f1b57272e42a3d851d3cc6d951b4f4d2e7a963914468a2",
             "0x000000000000000000000000000000000000000000000000000001657f9d5fbf"
           ] }
    transaction_hash { "0x2c12c54a55428b56fd35b5882d5087d6cf2e20a410dc3a1b6515c2ecc3f53f22" }
    transaction_index { "0x0" }
    transaction_log_index { "0x0" }

    association :tx, factory: :transaction
  end

  factory :erc20_event_log, class: EventLog do
    address { "0x0b9a7bad10e78aefbe6d99e61c7ea2a23c3ec888" }
    topics { [
             "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
             "0x000000000000000000000000ac30bce77cf849d869aa37e39b983fa50767a2dd",
             "0x0000000000000000000000006005ed6b942c99533b896b95fe8a90c7a7ecbf6a"
           ] }
    data { "0x000000000000000000000000000000000000000000000000000000000000000a" }
    block_hash { "0xa2574fbd6fe9083ad8a1729630d1fa2c227f0a6df2dbb1f0d6d69faa4145c5cb" }
    block_number { "0x18a1ec" }
    transaction_hash { "0x14b06be4067ba65d05e41d8821e2cf7d572a65b1bf53857a6a504ec42e69fdfd" }
    transaction_index { "0x0" }
    log_index { "0x0" }
    transaction_log_index { "0x0" }

    association :tx, factory: :transaction
  end
end
