require 'rails_helper'

RSpec.describe Message do
  let(:content) { "0x0a770a28636235313466303134313761626366626431663632393961306434313961326430656165613362361220323066613965333731663531343062613862656533333632313735396338343718e80720db8512322000000000000000000000000000000000000000000000000000000000000010003801124113ec0f1aba3247937c069d250faa708f53162b2a8059597f3df4d1a74ff1c2214eb6251e4bb336a2cc3b6c432fe1e0c79ba9d464fdd8ab8eb525cb2ac93c8a7500" }
  let(:to) { "0xcb514f01417abcfbd1f6299a0d419a2d0eaea3b6" }
  let(:quota) { 1000 }
  let(:value) { "0x0000000000000000000000000000000000000000000000000000000000001000" }
  let(:message) { Message.new(content) }
  let(:unverified_transaction) { message.unverified_transaction }
  let(:transaction) { unverified_transaction[:transaction] }

  it "quota should be 1000" do
    expect(transaction[:quota]).to eq quota
  end

  it "value should be eq" do
    expect(message.value).to eq value
  end

  it "to should be eq" do
    expect(message.to).to eq to
  end

  context "version 0" do
    let(:content) { transaction_result_two[:content] }

    it "chain_id" do
      expect(message.version).to eq 0
      expect(message.chain_id).to eq message.unverified_transaction[:transaction][:chain_id]
    end

    it "to" do
      expect(message.version).to eq 0
      expected_to = message.unverified_transaction[:transaction][:to]
      expect(message.to).to eq expected_to
    end
  end

  context "version 1" do
    let(:content) { transaction_result_version1[:content] }

    it "chain_id" do
      chain_id_v1 = message.unverified_transaction[:transaction][:chain_id]

      expect(message.version).to eq 1
      expect(message.chain_id).to eq chain_id_v1
    end

    it "to" do
      to_v1 = message.unverified_transaction[:transaction][:to]

      expect(message.version).to eq 1
      expect(message.to).to eq to_v1
    end
  end

end
