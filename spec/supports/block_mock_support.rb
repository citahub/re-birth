module BlockMockSupport
  extend ActiveSupport::Concern

  included do
    def stub_request_wrapper(method, params, result)
      include_hash = if params.nil?
                       { method: method }
                     else
                       { method: method, params: params }
                     end
      stub_request(:post, ENV["CITA_URL"])
        .with(
          body: hash_including(include_hash),
          headers: { "Content-Type": "application/json" }
        )
        .to_return(
          status: 200,
          body: { jsonrpc: "2.0", id: 83, result: result }.to_json
        )
    end

    def stub_request_error_wrapper(method, params, error, status: 200, json_rpc: "2.0", id: 83)
      include_hash = if params.nil?
                       { method: method }
                     else
                       { method: method, params: params }
                     end

      stub_request(:post, ENV["CITA_URL"])
        .with(
          body: hash_including(include_hash),
          headers: { "Content-Type": "application/json" }
        )
        .to_return(
          status: status,
          body: { jsonrpc: json_rpc, id: id, error: error }.to_json
        )
    end

    let(:block_number_result) { "0x1" }
    let(:mock_block_number) do
      stub_request_wrapper("blockNumber", nil, block_number_result)
    end

    let(:block_zero_hash) { "0x542ff7aeccbd2b269c36e134e3c0a1be103b389dc9ed90a55c1d506e00b77b81" }
    let(:block_zero_result) do
      {
        "version": 0,
        "hash": block_zero_hash,
        "header": {
          "timestamp": 1529377997246,
          "prevHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "number": "0x0",
          "stateRoot": "0x9b3609aca48d23cadcbab0d768fa0d2187807a23f4ae19742db128a9a64f3bfc",
          "transactionsRoot": "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
          "receiptsRoot": "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
          "gasUsed": "0x0",
          "proof": nil,
          "proposer": "0x0000000000000000000000000000000000000000"
        },
        "body": {
          "transactions": []
        }
      }
    end
    let(:mock_get_block_by_number_zero) do
      stub_request_wrapper("getBlockByNumber", ["0x0", true], block_zero_result)
    end

    let(:block_zero_params_error_code) { -32700 }
    let(:block_zero_params_error_message) { "data did not match any variant of untagged enum BlockNumber" }
    let(:block_zero_params_error) do
      {
        code: block_zero_params_error_code,
        message: block_zero_params_error_message,
      }
    end
    let(:mock_get_block_by_number_zero_params_error) do
      stub_request_error_wrapper("getBlockByNumber", ["a", true], block_zero_params_error)
    end

    let(:block_one_hash) { "0xa18f9c384107d9a4fcd2fae656415928bd921047519fea5650cba394f6b6142b" }
    let(:block_one_result) do
      {
        "version" => 0,
        "hash" => block_one_hash,
        "header" => {
          "timestamp" => 1528702183591,
          "prevHash" => "0xda8991b9cbc7f7bc56e94abbd7056dffc501603a4ab6bcaa7e2ed08b3e58e554",
          "number" => "0x1",
          "stateRoot" => "0x048523e8326427968d05673210cc77a8f76e60d0b9170d1bdc1d49c131da9c85",
          "transactionsRoot" => "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
          "receiptsRoot" => "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
          "gasUsed" => "0x0",
          "proof" => nil,
          "proposer" => "0x91827976af27e1fd405469b00dc8d3b0ea2203f6"
        },
        "body" => {
          "transactions" => [
            {
              "hash": "0x4b364ce2e607c57200995ee39ecdd98f5749107752125383c2df5058e53be2f7",
              "content": "0x0a770a28636235313466303134313761626366626431663632393961306434313961326430656165613362361220323066613965333731663531343062613862656533333632313735396338343718e80720db8512322000000000000000000000000000000000000000000000000000000000000010003801124113ec0f1aba3247937c069d250faa708f53162b2a8059597f3df4d1a74ff1c2214eb6251e4bb336a2cc3b6c432fe1e0c79ba9d464fdd8ab8eb525cb2ac93c8a7500"
            }
          ]
        }
      }
    end
    let(:mock_get_block_by_number_one) do
      stub_request_wrapper("getBlockByNumber", ["0x1", true], block_one_result)
    end

    # CITA 0.20 version 0
    let(:block_two_hash) { "0x11296e25112b474c9b7ced9f3009ec86447a02649257f0a667ad863d42e70f94" }
    let(:block_two_result) do
      {
        "version" => 0,
        "hash" => block_two_hash,
        "header" => {
          "proof" => {
            "Bft" => {
              "round" => 0,
              "height" => 1,
              "commits" => {
                "0x0247ad138ca1c24ae6411b7de7135b6681161a9f" => "0xe571c2c4a3c07c2e86df68b2b6b1fe63039b14150fb0de4b5cbf04fa046b210e162e390650e8f71144f8798fee21039aaf43d945cc32d1c1641bde9f1607762100",
                "0xa9ee1efa9c0a1c6a6562085df235a7eaf8ea1b6b" => "0x847f8c5c606483f251164270aa2859ef035157fc11ac19de67ddd86060e0c38b2e4842ed005adaa2f553629ca9faab37dbed2b5a5cf0be78df49b758fa2aeeb800",
                "0xc706b13689816c3db4a07294052b6b17eb0bf0ef" => "0xf97598cf984c9595a8c6c1e64f894e6eac27a6f02c84223a4a42aa250790602c4ec7662b8b4addc7db8009b0b1cd3863260fb41f9776442c8b19e1a9ed9a8aca00",
                "0xde1a3908335c98fbc87c510c684dea75c8f097d4" => "0xce533a4bb840d0d281dae7fe5e4e38928e58c2b08bced63a751f725369ef7d0175c5e35aae0d0dff525f800dc95a2182ea4bcf49ec0b281fff3e9e079dc9965100"
              },
              "proposal" => "0xf51f66927ee30ed016d452e463afed6f993ce463b7507c76d3e70bed81fba3ac"
            }
          },
          "number" => "0x2",
          "prevHash" => "0xd2dcee66754b29abf46d50560b3231c98ec2218e4d5b31e85114ed8dab9da319",
          "proposer" => "0xde1a3908335c98fbc87c510c684dea75c8f097d4",
          "quotaUsed" => "0x5208",
          "stateRoot" => "0x049550848579399cd08046f80e0c5776a3755381450c94f3e90c95f181debddd",
          "timestamp" => 1541058467067,
          "receiptsRoot" => "0x2ed456f96c1cf846ade72478180ab38184d740a2dea4af059c608961a0496e6d",
          "transactionsRoot" => "0x5ddd3cac30321f03ca660054449601b096090445b3fa77f1504c4464eb358bbb"
        },
        "body" => {
          "transactions" => [
            {
              "hash" => "0x5ddd3cac30321f03ca660054449601b096090445b3fa77f1504c4464eb358bbb",
              "content" => "0x0a780a28363564643732376436353332316530343263346131306666643264356339326234373334353431351220376161373438343630653836343037623931363632363765626438346633636418b0ea0120a7eb03322000000000000000000000000000000000000000000000000000000000000003e838011241f8691d76e72c26a589d617aaa5da51445174fedfbeb4c9517abd7629d0f1fdbe49b784cc762f3656db9ae89f5ac44618bc96d490bacf9f8239f67761fb8b9f9700"
            }
          ]
        }
      }
    end
    let(:mock_get_block_by_number_two) do
      stub_request_wrapper("getBlockByNumber", ["0x2", true], block_two_result)
    end

    # CITA 0.20 version 1
    let(:block_hash_version1) { "0x7137d7989519127f76667948edb14cec9c7427c4ce6667a63aeeebcb4dcff0cf" }
    let(:block_result_version1) do
      {
        "body": {
          "transactions": [
            {
              "content": "0x0a86011220336635633630373433643131346437373965313032373432356534353163343618b0ea0120e7f203322000000000000000000000000000000000000000000000000000000000000003e840014a14d22b603d6abd259699c8b048f55c757f6387f286522000000000000000000000000000000000000000000000000000000000000000011241f3e9e358f507db55f3e7fc996c879d87d3cb70254c73885b7292d0b5217924f83656f0741081048b0027c71738e6c9b98b20717711a91bdba1e44176aa71cf7501",
              "hash": "0x0b607a613e9c95113145ae5221ff30963823bb6914d9d8f6eb3a6b37c8fdfbc4"
            }
          ]
        },
        "hash": block_hash_version1,
        "header": {
          "number": "0x3",
          "prevHash": "0x641d3edb4782d9562fcb286a46aa6ec28b206ea713205247fa6deac37ea5b6b3",
          "proof": {
            "Bft": {
              "commits": {
                "0x51eae20c2c31ab79b6044d88ce1e4094d9fd924b": "0x66fae3750e9585848548d09f117e3e05cc15c4d803bb0a02268437c16a0d3dd12fa84c2e41a86054eb5a5861fa1698773c1bbaa3a3fd999da33d5045a0e80d8301",
                "0x5c2bdf306f590a4f14f6c721ab40ab66fa8d7694": "0x86147e9182fad6a1b45a39f35bcf83799c703f25a61cbc76b77eae7c2af624bd6ccea7e0e00f4d8df89e0d6f4b4eb2596e6b0cf01c13d39a02181772a6c6157c00",
                "0xc57db273f5a43bea2b1f8831a83787190594c602": "0x25ac5d57d2397517b9d15cc9a850e99b01cc083466a00f7266659341b65765e6436b69c5da2362d52fd468dd7ddd9c2d7fed631dbf488167e75be359b365d90701",
                "0xef4927a5fc2957cc094c72a89c13a80fbae2db08": "0x9ce0c7954c181cd05e8f5fa3f11ef0eadc9cb7aefd7cf9f5a5b64fb6f5f2bbde12ff5d325a7076c9445b5dc1a392c2374d384bd4021c8756dfde3667990a2d5101"
              },
              "height": 2,
              "proposal": "0xf841590d320a7424b9d6fe02310feb00733217283618b8c3d3a1da0ddfcf5f53",
              "round": 0
            }
          },
          "proposer": "0x5c2bdf306f590a4f14f6c721ab40ab66fa8d7694",
          "quotaUsed": "0x5208",
          "receiptsRoot": "0x8894e8dbaa1e40818e1c22d14a2b8445fb9604bff8280ef074a76f4ebcede8dd",
          "stateRoot": "0xdb8f94500aa9addc6f1531c61487ff132f31f8f751d6d480bca39280eb8efa3b",
          "timestamp": 1541062810611,
          "transactionsRoot": "0x0b607a613e9c95113145ae5221ff30963823bb6914d9d8f6eb3a6b37c8fdfbc4"
        },
        "version": 1
      }
    end
    let(:mock_get_block_by_number_version1) do
      stub_request_wrapper("getBlockByNumber", ["0x3", true], block_result_version1)
    end

    let(:transaction_hash) { "0x4b364ce2e607c57200995ee39ecdd98f5749107752125383c2df5058e53be2f7" }
    let(:transaction_result) do
      {
        "hash": transaction_hash,
        "content": "0x0a770a28636235313466303134313761626366626431663632393961306434313961326430656165613362361220323066613965333731663531343062613862656533333632313735396338343718e80720db8512322000000000000000000000000000000000000000000000000000000000000010003801124113ec0f1aba3247937c069d250faa708f53162b2a8059597f3df4d1a74ff1c2214eb6251e4bb336a2cc3b6c432fe1e0c79ba9d464fdd8ab8eb525cb2ac93c8a7500",
        "blockNumber": "0x1",
        "blockHash": block_one_hash,
        "index": "0x0"
      }
    end
    let(:mock_get_transaction) do
      stub_request_wrapper("getTransaction", [transaction_hash], transaction_result)
    end

    # CITA 0.20 version 0
    let(:transaction_hash_two) { "0x5ddd3cac30321f03ca660054449601b096090445b3fa77f1504c4464eb358bbb" }
    let(:transaction_result_two) do
      {
        hash: transaction_hash_two,
        content: "0x0a780a28363564643732376436353332316530343263346131306666643264356339326234373334353431351220376161373438343630653836343037623931363632363765626438346633636418b0ea0120a7eb03322000000000000000000000000000000000000000000000000000000000000003e838011241f8691d76e72c26a589d617aaa5da51445174fedfbeb4c9517abd7629d0f1fdbe49b784cc762f3656db9ae89f5ac44618bc96d490bacf9f8239f67761fb8b9f9700",
        blockNumber: "0x2",
        blockHash: block_two_hash,
        index: "0x0"
      }
    end
    let(:mock_get_transaction_two) do
      stub_request_wrapper("getTransaction", [transaction_hash_two], transaction_result_two)
    end

    # CITA 0.20 version 1
    let(:transaction_hash_version1) { "0x0b607a613e9c95113145ae5221ff30963823bb6914d9d8f6eb3a6b37c8fdfbc4" }
    let(:transaction_result_version1) do
      {
        "blockHash": "0x7137d7989519127f76667948edb14cec9c7427c4ce6667a63aeeebcb4dcff0cf",
        "blockNumber": "0x3",
        "content": "0x0a86011220336635633630373433643131346437373965313032373432356534353163343618b0ea0120e7f203322000000000000000000000000000000000000000000000000000000000000003e840014a14d22b603d6abd259699c8b048f55c757f6387f286522000000000000000000000000000000000000000000000000000000000000000011241f3e9e358f507db55f3e7fc996c879d87d3cb70254c73885b7292d0b5217924f83656f0741081048b0027c71738e6c9b98b20717711a91bdba1e44176aa71cf7501",
        "hash": transaction_hash_version1,
        "index": "0x0"
      }
    end
    let(:mock_get_transaction_version1) do
      stub_request_wrapper("getTransaction", [transaction_hash_version1], transaction_result_version1)
    end

    # CITA 0.20 version 0
    let(:transaction_receipt_result_two) do
      {
        "contractAddress": nil,
        "cumulativeQuotaUsed": "0x5208",
        "quotaUsed": "0x5208"
      }
    end
    let(:mock_get_transaction_receipt_two) do
      stub_request_wrapper("getTransactionReceipt", [transaction_hash_two], transaction_receipt_result_two)
    end

    # CITA 0.20 version 1
    let(:transaction_receipt_result_version1) do
      {
        "contractAddress": nil,
        "cumulativeQuotaUsed": "0x5208",
        "quotaUsed": "0x5208"
      }
    end
    let(:mock_get_transaction_receipt_version1) do
      stub_request_wrapper("getTransactionReceipt", [transaction_hash_version1], transaction_receipt_result_version1)
    end

    let(:transaction_params_error_code) { -32700 }
    let(:transaction_params_error_message) { "invalid format: [0x0]" }
    let(:transaction_params_error) do
      {
        code: transaction_params_error_code,
        message: transaction_params_error_message
      }
    end
    let(:mock_get_transaction_params_error) do
      stub_request_error_wrapper("getTransaction", ["0x0"], transaction_params_error)
    end

    let(:transaction_receipt_result) do
      {
        "contractAddress": "0x89be88054e2ee94911549be521ab1241c7700a1b",
        "gasUsed": "0x2d483"
      }
    end
    let(:mock_get_transaction_receipt) do
      stub_request_wrapper("getTransactionReceipt", [transaction_hash], transaction_receipt_result)
    end

    let(:meta_data_result) do
      {
        "blockInterval": 3000,
        "chainId": 1,
        "chainName": "test-chain",
        "genesisTimestamp": 1530164125967,
        "operator": "test-operator",
        "tokenAvatar": "https://avatars1.githubusercontent.com/u/35361817",
        "tokenName": "Nervos",
        "tokenSymbol": "NOS",
        "validators": [
          "0x365d339609728590ec0803a73b95c24fde718846",
          "0xf1551b918a4f43c1b72d322b8f91d4caebc249de",
          "0x6e66c49ed7cf07754cd5794a43d41704b7c1e217",
          "0xb4061fa8e18654a7d51fef3866d45bb1dc688717"
        ],
        "website": "https://www.example.com"
      }
    end
    let(:mock_get_meta_data) do
      stub_request_wrapper("getMetaData", ["0x0"], meta_data_result)
      stub_request_wrapper("getMetaData", ["0x1"], meta_data_result)
      stub_request_wrapper("getMetaData", ["latest"], meta_data_result)
    end

    let(:meta_data_params_error_code) { -32700 }
    let(:meta_data_params_error_message) { "data did not match any variant of untagged enum BlockNumber" }
    let(:meta_data_params_error) do
      {
        code: meta_data_params_error_code,
        message: meta_data_params_error_message
      }
    end
    let(:mock_get_meta_data_params_error) do
      stub_request_error_wrapper("getMetaData", ["a"], meta_data_params_error)
    end

    let(:account_address) { "0x0dcf740686de1fe9e9faa4b519767a872e1cf69e" }
    let(:balance_result) do
      "0x0"
    end
    let(:mock_get_balance) do
      stub_request_wrapper("getBalance", [account_address, "0x0"], balance_result)
    end

    let(:balance_params_error_code) { -32700 }
    let(:balance_params_error_message) { "invalid format: [0x0]" }
    let(:balance_params_error) do
      {
        code: balance_params_error_code,
        message: balance_params_error_message
      }
    end
    let(:mock_get_balance_params_error) do
      stub_request_error_wrapper("getBalance", ["0x0", "0x0"], balance_params_error)
    end

    let(:abi_result) do
      "0x"
    end
    let(:mock_get_abi) do
      stub_request_wrapper("getAbi", [account_address, "0x0"], abi_result)
    end

    let(:abi_params_error_code) { -32700 }
    let(:abi_params_error_message) { "invalid format: [0x0]" }
    let(:abi_params_error) do
      {
        code: abi_params_error_code,
        message: abi_params_error_message
      }
    end
    let(:mock_get_abi_params_error) do
      stub_request_error_wrapper("getAbi", ["0x0", "0x0"], abi_params_error)
    end

    let(:mock_all) do
      mock_block_number
      mock_get_block_by_number_zero
      mock_get_block_by_number_zero_params_error
      mock_get_block_by_number_one
      mock_get_block_by_number_two
      mock_get_block_by_number_version1
      mock_get_transaction
      mock_get_transaction_params_error
      mock_get_transaction_receipt
      mock_get_transaction_two
      mock_get_transaction_receipt_two
      mock_get_transaction_version1
      mock_get_transaction_receipt_version1
      mock_get_meta_data
      mock_get_meta_data_params_error
      mock_get_balance
      mock_get_balance_params_error
      mock_get_abi
      mock_get_abi_params_error
    end
  end
end
