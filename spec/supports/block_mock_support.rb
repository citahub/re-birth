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
    end

    let(:account_address) { "0x0dcf740686de1fe9e9faa4b519767a872e1cf69e" }
    let(:balance_result) do
      "0x0"
    end
    let(:mock_get_balance) do
      stub_request_wrapper("getBalance", [account_address, "0x0"], balance_result)
    end

    let(:abi_result) do
      "0x"
    end
    let(:mock_get_abi) do
      stub_request_wrapper("getAbi", [account_address, "0x0"], abi_result)
    end

    let(:mock_all) do
      mock_block_number
      mock_get_block_by_number_zero
      mock_get_block_by_number_one
      mock_get_transaction
      mock_get_transaction
      mock_get_transaction_receipt
      mock_get_meta_data
      mock_get_balance
      mock_get_abi
    end
  end
end
