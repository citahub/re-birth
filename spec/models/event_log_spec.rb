require 'rails_helper'

RSpec.describe EventLog, type: :model do
  let(:transaction) { create :transaction }
  context "validates" do
    it "regular should be valid" do
      expect(build :event_log, tx: transaction).to be_valid
    end

    context "address" do
      it "presence" do
        expect(build :event_log, address: nil, tx: transaction).to be_invalid
      end
    end

    context "transaction" do
      it "transaction hash must be present" do
        event_log = build :event_log, transaction_hash: nil, tx: nil
        expect(event_log).to be_invalid
      end
    end

    context "log_index" do
      it "log index must be present" do
        event_log = build :event_log, log_index: nil, tx: nil, transaction_hash: transaction.tx_hash
        expect(event_log).to be_invalid
      end
    end

    context "unique of transaction hash & transaction log index" do
      it "transaction hash not unique" do
        create :event_log, tx: transaction, transaction_log_index: 0
        event_log = build :event_log, tx: transaction, transaction_log_index: 1
        expect(event_log).to be_valid
      end

      it "txhash and log index should not be same" do
        create :event_log, tx: transaction, transaction_log_index: 0
        event_log = build :event_log, tx: transaction, transaction_log_index: 0

        expect(event_log).to be_invalid
      end
    end
  end
end
