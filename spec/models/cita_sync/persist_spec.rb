require 'rails_helper'

RSpec.describe CitaSync::Api, type: :model do

  before do
    mock_all
  end

  context "save block" do
    it "save block with it's transaction info in body" do
      expect {
        CitaSync::Persist.save_block("0x0")
      }.to change { ::Block.count }.by(1)
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

    it "save transaction with block param" do
      block = CitaSync::Persist.save_block("0x1")
      transaction = CitaSync::Persist.save_transaction(transaction_hash, block)
      expect(transaction.cita_hash).to eq transaction_hash
      expect(transaction.errors.full_messages).to be_empty
      expect(transaction.block).to eq block
    end

    it "save transaction without block will be fail" do
      transaction = CitaSync::Persist.save_transaction(transaction_hash)
      expect(transaction.errors.full_messages).not_to be_empty
    end
  end

  context "save meta data" do
    it "save success" do
      CitaSync::Persist.save_block("0x0")
      meta_data = CitaSync::Persist.save_meta_data("0x0")
      expect(meta_data.errors.full_messages).to be_empty
    end
  end

  context "save balance" do
    it "save success" do
      balance, = CitaSync::Persist.save_balance(account_address, "0x0")
      expect(balance.errors.full_messages).to be_empty
    end
  end

  context "save abi" do
    it "save abi" do
      abi, = CitaSync::Persist.save_abi(account_address, "0x0")
      expect(abi.errors.full_messages).to be_empty
    end
  end

  context "save block with infos" do
    it "save success" do
      CitaSync::Persist.save_block_with_infos("0x1")
      block = Block.first
      transaction = Transaction.first
      meta_data = MetaData.first
      expect(Block.count).to eq 1
      expect(Transaction.count).to eq 1
      expect(transaction.block_number).to eq block.header["number"]
      expect(transaction.block).to eq block
      expect(meta_data.block).to eq block
    end
  end

  context "save blocks with infos" do
    it "save blocks with transactions with empty db" do
      CitaSync::Persist.save_blocks_with_infos
      expect(Block.count).to eq 2
      expect(Transaction.count).to eq 1
      expect(MetaData.count).to eq Block.count
    end

    it "save blocks with transactions with exist block" do
      CitaSync::Persist.save_block("0x0")
      CitaSync::Persist.save_blocks_with_infos
      expect(Block.count).to eq 2
      expect(Transaction.count).to eq 1
    end
  end
end
