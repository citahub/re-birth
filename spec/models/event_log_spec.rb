require 'rails_helper'

RSpec.describe EventLog, type: :model do
  context "validates" do
    it "regular should be valid" do
      expect(build :event_log).to be_valid
    end

    context "address" do
      it "presence" do
        expect(build :event_log, address: nil).to be_invalid
      end
    end

    context "transaction" do
      it "transaction hash must be present" do
        event_log = build :event_log, transaction_hash: nil
        expect(event_log).to be_invalid
      end
    end

    context "log_index" do
      it "log index must be present" do
        event_log = build :event_log, log_index: nil
        expect(event_log).to be_invalid
      end
    end

    context "unique of transaction hash & log index" do
      it "transaction hash not unique" do
        create :event_log, transaction_hash: "aaa", log_index: "0x0"
        event_log = build :event_log, transaction_hash: "aaa", log_index: "0x1"
        expect(event_log).to be_valid
      end

      it "log_index not unique" do
        create :event_log, transaction_hash: "aaa"
        event_log = build :event_log, transaction_hash: "bbb"

        expect(event_log).to be_valid
      end

      it "txhash and log index should not be same" do
        create :event_log
        event_log = build :event_log

        expect(event_log).to be_invalid
      end
    end
  end
end
