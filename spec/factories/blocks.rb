FactoryBot.define do
  factory :block do
    cita_hash "0x9b76631fa409a4c69f0726d16b9656d54fcef3aa0400d95b5f8e4413aacfe965"
    version 0
    block_number 0
    transaction_count 0
    header({
      "proof" => nil,
      "number" => "0x0",
        "gasUsed" => "0x0",
        "prevHash" => "0x0000000000000000000000000000000000000000000000000000000000000000",
        "proposer" => "0x0000000000000000000000000000000000000000",
        "stateRoot" => "0xc9509aed05b800c7d9a27395b1f7cdde9428f56a72e9f07661c1f1731d7dda44",
        "timestamp" => 1530164125967,
        "receiptsRoot" => "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
        "transactionsRoot" => "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421"
    })

    body({
           "transactions" => []
         })
  end
end
