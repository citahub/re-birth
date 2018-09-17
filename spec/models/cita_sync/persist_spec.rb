require 'rails_helper'

RSpec.describe CitaSync::Api, type: :model do

  before do
    mock_all
    ENV["SAVE_BLOCKS"] = "true"
  end

  def set_false
    ENV["SAVE_BLOCKS"] = "false"
  end

  context "save_blocks?" do
    it "'true' should be true" do
      ENV["SAVE_BLOCKS"] = "true"
      expect(CitaSync::Persist.save_blocks?).to be true
    end

    it "'false' should be false" do
      ENV["SAVE_BLOCKS"] = "false"
      expect(CitaSync::Persist.save_blocks?).to be false
    end

    it "anything other than 'false' should be true" do
      ENV["SAVE_BLOCKS"] = "123"
      expect(CitaSync::Persist.save_blocks?).to be true
    end
  end

  context "save block" do
    it "save block with it's transaction info in body" do
      expect {
        CitaSync::Persist.save_block("0x0")
      }.to change { ::Block.count }.by(1)
    end

    it "with error params" do
      sync_error = CitaSync::Persist.save_block("a")
      expect(sync_error.method).to eq "getBlockByNumber"
      expect(sync_error.params).to eq ["a", true]
      expect(sync_error.code).to eq block_zero_params_error_code
      expect(sync_error.message).to eq block_zero_params_error_message
      expect(sync_error.data).to be nil
    end

    it "with SAVE_BLOCKS set false" do
      set_false
      expect {
        CitaSync::Persist.save_block("0x0")
      }.to change { ::Block.count }.by(0)
    end
  end

  context "save transaction" do
    it "save transaction" do
      block = CitaSync::Persist.save_block("0x1")
      transaction = CitaSync::Persist.save_transaction(transaction_hash)
      expect(transaction.cita_hash).to eq transaction_hash
      expect(transaction.errors.full_messages).to be_empty
      expect(transaction.block).to eq block
    end

    it "save transaction with SAVE_BLOCKS set false" do
      set_false
      transaction = CitaSync::Persist.save_transaction(transaction_hash)
      expect(transaction.cita_hash).to eq transaction_hash
      expect(transaction.errors.full_messages).to be_empty
      expect(transaction.block).to be nil
    end

    # it "save transaction with block param" do
    #   block = CitaSync::Persist.save_block("0x1")
    #   transaction = CitaSync::Persist.save_transaction(transaction_hash, block)
    #   expect(transaction.cita_hash).to eq transaction_hash
    #   expect(transaction.errors.full_messages).to be_empty
    #   expect(transaction.block).to eq block
    # end

    it "save transaction without block will be success" do
      transaction = CitaSync::Persist.save_transaction(transaction_hash)
      expect(transaction.errors.full_messages).to be_empty
    end

    it "with error params" do
      params = ["0x0"]
      sync_error = CitaSync::Persist.save_transaction(*params)

      expect(sync_error.method).to eq "getTransaction"
      expect(sync_error.params).to eq params
      expect(sync_error.code).to eq transaction_params_error_code
      expect(sync_error.message).to eq transaction_params_error_message
      expect(sync_error.data).to be nil
    end
  end

  context "save event logs" do
    let(:event_log_attrs) do
      {
        "address": "0x35bd452c37d28beca42097cfd8ba671c8dd430a1",
        "blockHash": "0x2bb2dab1bc4e332ca61fe15febf06a1fd09738d6304d76c5dd9b57cb46880e28",
        "blockNumber": "0xf11e2",
        "data": "0x00000000000000000000000046a23e25df9a0f6c18729dda9ad1af3b6a1311600000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000001c68656c6c6f20776f726c64206174203135333534343433343437363700000000",
        "logIndex": "0x0",
        "topics": [
          "0xe4af93ca7e370881e6f1b57272e42a3d851d3cc6d951b4f4d2e7a963914468a2",
          "0x000000000000000000000000000000000000000000000000000001657f9d5fbf"
        ],
        "transactionHash": "0x2c12c54a55428b56fd35b5882d5087d6cf2e20a410dc3a1b6515c2ecc3f53f22",
        "transactionIndex": "0x0",
        "transactionLogIndex": "0x0"
      }
    end

    it "save success" do
      event_logs = CitaSync::Persist.save_event_logs([event_log_attrs])

      expect(event_logs.size).to eq 1
      el = event_logs.first

      event_log_attrs.transform_keys { |key| key.to_s.underscore }.each do |key, value|
        expect(el.public_send key).to eq value
      end
    end
  end

  context "save balance" do
    it "save success" do
      balance, = CitaSync::Persist.save_balance(account_address, "0x0")
      expect(balance.errors.full_messages).to be_empty
    end

    it "with error params" do
      params = ["0x0", "0x0"]
      sync_error, = CitaSync::Persist.save_balance(*params)
      expect(sync_error.method).to eq "getBalance"
      expect(sync_error.params).to eq params
      expect(sync_error.code).to eq balance_params_error_code
      expect(sync_error.message).to eq balance_params_error_message
      expect(sync_error.data).to be nil
    end
  end

  context "save abi" do
    it "save abi" do
      abi, = CitaSync::Persist.save_abi(account_address, "0x0")
      expect(abi.errors.full_messages).to be_empty
    end

    it "with error params" do
      params = ["0x0", "0x0"]
      sync_error, = CitaSync::Persist.save_abi(*params)
      expect(sync_error.method).to eq "getAbi"
      expect(sync_error.params).to eq params
      expect(sync_error.code).to eq abi_params_error_code
      expect(sync_error.message).to eq abi_params_error_message
      expect(sync_error.data).to be nil
    end
  end

  context "save block with infos" do
    it "save success" do
      CitaSync::Persist.save_block_with_infos("0x1")
      block = Block.first
      transaction = Transaction.first
      expect(Block.count).to eq 1
      expect(Transaction.count).to eq 1
      expect(transaction.block_number).to eq block.header["number"]
      expect(transaction.block).to eq block
    end
  end

  context "save blocks with infos" do
    it "save blocks with transactions with empty db" do
      CitaSync::Persist.save_blocks_with_infos
      expect(Block.count).to eq 2
      expect(Transaction.count).to eq 1
    end

    it "save blocks with transactions with exist block" do
      CitaSync::Persist.save_block("0x0")
      CitaSync::Persist.save_blocks_with_infos
      expect(Block.count).to eq 2
      expect(Transaction.count).to eq 1
    end
  end

  context "handle error" do
    let(:method) { "getBlockByNumber" }
    let(:params) { [123, false] }
    let(:code) { -124 }
    let(:message) { "invalid params" }
    let(:data) do
      {
        "error" => {
          "code" => code,
          "message" => message
        }
      }
    end
    it "save an error" do
      sync_error = CitaSync::Persist.send(:handle_error, method, params, data["error"])
      expect(sync_error.method).to eq method
      expect(sync_error.params).to match_array(params)
      expect(sync_error.code).to eq code
      expect(sync_error.message).to eq message
      expect(sync_error.data).to be nil
    end

    it "with no error info" do
      sync_error = CitaSync::Persist.send(:handle_error, method, params, {})
      expect(sync_error).to be nil
    end
  end
end
