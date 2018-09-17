module EventLogMockSupport
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

    let(:contracts_result_one) do
      {
        "address": "0x35bd452c37d28beca42097cfd8ba671c8dd430a1",
        "topics": [
          "0xe4af93ca7e370881e6f1b57272e42a3d851d3cc6d951b4f4d2e7a963914468a2",
          "0x000000000000000000000000000000000000000000000000000001657f9d5fbf"
        ],
        "data": "0x00000000000000000000000046a23e25df9a0f6c18729dda9ad1af3b6a1311600000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000001c68656c6c6f20776f726c64206174203135333534343433343437363700000000",
        "blockHash": "0x2bb2dab1bc4e332ca61fe15febf06a1fd09738d6304d76c5dd9b57cb46880e28",
        "blockNumber": "0xf11e2",
        "transactionHash": "0x2c12c54a55428b56fd35b5882d5087d6cf2e20a410dc3a1b6515c2ecc3f53f22",
        "transactionIndex": "0x0",
        "logIndex": "0x0",
        "transactionLogIndex": "0x0"
      }
    end

    let(:contracts_result_two) do
      {
        "address": "0x35bd452c37d28beca42097cfd8ba671c8dd430a1",
        "topics": [
          "0xe4af93ca7e370881e6f1b57272e42a3d851d3cc6d951b4f4d2e7a963914468a2",
          "0x000000000000000000000000000000000000000000000000000001657fb2a127"
        ],
        "data": "0x00000000000000000000000046a23e25df9a0f6c18729dda9ad1af3b6a1311600000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000001c68656c6c6f20776f726c64206174203135333534343537333737363700000000",
        "blockHash": "0xbe12116de62427ffeb070c3f2691a182ba70dcdbb3062a3d2b5dc2c90af8dd58",
        "blockNumber": "0xf13b2",
        "transactionHash": "0xad33434310a9c00efa39eb250765c7bdd8624ea74ef821f3d6ef6642ec48fffc",
        "transactionIndex": "0x0",
        "logIndex": "0x0",
        "transactionLogIndex": "0x0"
      }
    end

    let(:contracts_result) do
      [contracts_result_one, contracts_result_two]
    end


    let(:mock_event_logs) do
      stub_request_wrapper("getLogs", [{address: "0x35bd452c37d28beca42097cfd8ba671c8dd430a1", fromBlock: "0x0"}], contracts_result)
      stub_request_wrapper("getLogs", [{address: "0x35bd452c37d28beca42097cfd8ba671c8dd430a1", fromBlock: "0xf11e3"}], [contracts_result_two])
      stub_request_wrapper("getLogs", [{address: "0x35bd452c37d28beca42097cfd8ba671c8dd430a1", fromBlock: "0xf13b3"}], [])
    end
  end
end
