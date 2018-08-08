require 'rails_helper'

RSpec.describe LocalInfosConcern do
  class LocalInfos
    include LocalInfosConcern
  end

  let(:local_infos) { LocalInfos.new }


  context "get_block_by_number" do
    it "return nil if block is nil" do
      block = local_infos.get_block_by_number(["0x0", true])
      expect(block).to be nil
    end

    it "return serializer if block exist" do
      create :block
      block = local_infos.get_block_by_number(["0x0", true])
      expect(block).to be_a(ActiveModelSerializers::SerializableResource)
    end
  end

  context "get_block_by_hash" do
    let(:hash) { attributes_for(:block)[:cita_hash] }

    it "return nil if block is nil" do
      block = local_infos.get_block_by_hash([hash, true])
      expect(block).to be nil
    end

    it "return serializer if block exist" do
      create :block
      block = local_infos.get_block_by_hash([hash, true])
      expect(block).to be_a(ActiveModelSerializers::SerializableResource)
    end
  end

  context "get_transaction" do
    let(:hash) { attributes_for(:transaction)[:cita_hash] }

    it "return nil if transaction is nil" do
      transaction = local_infos.get_transaction([hash])
      expect(transaction).to be nil
    end

    it "return serializer if transaction exist" do
      create :transaction
      transaction = local_infos.get_transaction([hash])
      expect(transaction).to be_a(ActiveModelSerializers::SerializableResource)
    end
  end

  context "get_meta_data" do
    let(:block_number) { "0x0" }

    it "return nil if meta_data not exist" do
      meta_data = local_infos.get_meta_data([block_number])
      expect(meta_data).to be nil
    end

    it "return serializer if meta_data exist" do
      create :meta_data
      meta_data = local_infos.get_meta_data([block_number])
      expect(meta_data).to be_a(ActiveModelSerializers::SerializableResource)
    end
  end

  context "get_balance" do
    let(:block_number) { "0x0"}
    let(:balance_attr) { attributes_for(:balance) }
    let(:address) { balance_attr[:address] }

    it "return nil if balance not exist" do
      balance = local_infos.get_balance([address, block_number])
      expect(balance).to be nil
    end

    it "return value if balance exist" do
      create :balance
      balance = local_infos.get_balance([address, block_number])
      expect(balance).to eq balance_attr[:value]
    end
  end

  context "get_abi" do
    let(:block_number) { "0x0" }
    let(:abi_attr) { attributes_for :abi }
    let(:address) { abi_attr[:address] }

    it "return nil if abi not exist" do
      abi = local_infos.get_abi([address, block_number])
      expect(abi).to be nil
    end

    it "return value if abi exist" do
      create :abi
      abi = local_infos.get_abi([address, block_number])
      expect(abi).to eq abi_attr[:value]
    end
  end


end
