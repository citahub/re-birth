FactoryBot.define do
  factory :block do
    cita_hash { "0x9b76631fa409a4c69f0726d16b9656d54fcef3aa0400d95b5f8e4413aacfe965" }
    version { 0 }
    block_number { 0 }
    transaction_count { 0 }
    header { {
             "proof" => nil,
             "number" => "0x0",
             "quotaUsed" => "0x0",
             "prevHash" => "0x0000000000000000000000000000000000000000000000000000000000000000",
             "proposer" => "0x0000000000000000000000000000000000000000",
             "stateRoot" => "0xc9509aed05b800c7d9a27395b1f7cdde9428f56a72e9f07661c1f1731d7dda44",
             "timestamp" => 1530164125967,
             "receiptsRoot" => "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
             "transactionsRoot" => "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421"
           } }

    body { {
           "transactions" => []
         } }
  end

  factory :block_zero, class: Block do
    cita_hash { "0x542ff7aeccbd2b269c36e134e3c0a1be103b389dc9ed90a55c1d506e00b77b81" }
    version { 0 }
    block_number { 0 }
    transaction_count { 0 }
    header { {
             "timestamp": 1529377997246,
             "prevHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
             "number": "0x0",
             "stateRoot": "0x9b3609aca48d23cadcbab0d768fa0d2187807a23f4ae19742db128a9a64f3bfc",
             "transactionsRoot": "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
             "receiptsRoot": "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
             "quotaUsed": "0x0",
             "proof": nil,
             "proposer": "0x0000000000000000000000000000000000000000"
           } }
    body { {
           "transactions": []
         } }
  end

  factory :block_one, class: Block do
    cita_hash { "0xa18f9c384107d9a4fcd2fae656415928bd921047519fea5650cba394f6b6142b" }
    version { 0 }
    block_number { 1 }
    transaction_count { 1 }
    header { {
             "timestamp": 1528702183591,
             "prevHash": "0xda8991b9cbc7f7bc56e94abbd7056dffc501603a4ab6bcaa7e2ed08b3e58e554",
             "number": "0x1",
             "stateRoot": "0x048523e8326427968d05673210cc77a8f76e60d0b9170d1bdc1d49c131da9c85",
             "transactionsRoot": "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
             "receiptsRoot": "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
             "quotaUsed": "0x0",
             "proof": nil,
             "proposer": "0x91827976af27e1fd405469b00dc8d3b0ea2203f6"
           } }
    body { {
           "transactions": [
             {
               "hash": "0xee969624a87a51fc4acc958a3bb83ca32539ee54ebb4215668fe1029eeab59d4",
               "content": "0x0a1d186420e7192a14627306090abab3a6e1400e9345bc60c78a8bef57380112410422a3159ad636e779ad530dfca184ed3f88183f1be05be6dda4ad820791b0798fe1382cb0396c3563cc6d41f743722ea3918beb8fd343079c2b79eb085f699401"
             }
           ]
         } }
  end
end
