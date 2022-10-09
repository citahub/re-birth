require 'rails_helper'

RSpec.describe Erc20Transfer, type: :model do
  let(:tx) { create :transaction }
  let(:event_log) { create :erc20_event_log, tx: tx, block: tx.block }
  let(:data) { event_log.data }
  let(:topics) { event_log.topics }
  let(:address) { event_log.address }
  let(:erc20_transfer) { create :erc20_transfer, tx: tx, event_log: event_log, block: tx.block }
  let(:from) { erc20_transfer.from }
  let(:to) { erc20_transfer.to }
  let(:value) { erc20_transfer.value }

  context "save upcase" do
    it "saved downcase" do
      event_log.update!(address: event_log.address.upcase)
      address = event_log.reload.address
      transfer = Erc20Transfer.save_from_event_log event_log

      expect(transfer.address).to eq transfer.address.downcase
      expect(address).to eq address.upcase
    end
  end

  context "check event_topic" do
    it "success" do
      event = "Transfer(address,address,uint256)"
      topic = Ciri::Utils.to_hex(Ciri::Utils.keccak event)

      expect(Erc20Transfer::EVENT_TOPIC).to eq topic
    end
  end

  context "decode" do
    it "success" do
      decoded_info = Erc20Transfer.decode data, topics
      expect(decoded_info[:from]).to eq from
      expect(decoded_info[:to]).to eq to
      expect(decoded_info[:value]).to eq value
    end
  end

  context "transfer" do
    it "success" do
      expect(Erc20Transfer.transfer? event_log.topics).to be true
    end

    it "not erc20" do
      expect(Erc20Transfer.transfer? build(:event_log).topics).to be false
    end
  end

  context "save_from_event_log" do
    it "success" do
      transfer = Erc20Transfer.save_from_event_log event_log

      %i(address transaction_hash transaction_log_index log_index block_number block_hash).each do |attr|
        expect(transfer.send(attr)).to eq event_log.send(attr)
      end
    end
  end

  context "init_address" do
    it "success" do
      event_log

      expect {
        Erc20Transfer.init_address(event_log.address)
      }.to change { Erc20Transfer.count }.by(1)
    end
  end
end
