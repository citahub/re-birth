require 'rails_helper'

RSpec.describe SyncInfo, type: :model do
  let(:sync_info_attrs) { attributes_for :sync_info }
  context "validators" do
    it "be valid" do
      expect(build :sync_info).to be_valid
    end

    it "name should be presence" do
      expect(build :sync_info, name: nil).to be_invalid
    end

    it "name should be unique" do
      create :sync_info
      expect(build :sync_info, name: sync_info_attrs[:name]).to be_invalid
    end
  end


  context "current_block_number" do
    it "expect not exist return nil" do
      expect(SyncInfo.current_block_number).to be nil
    end

    it "expect return value if exist" do
      create :sync_info
      expect(SyncInfo.current_block_number).to eq sync_info_attrs[:value]
    end
  end

  context "current_block_number=" do
    let(:value) { 2 }
    it "create by block_number if not exist" do
      SyncInfo.current_block_number = value
      expect(SyncInfo.current_block_number).to eq value
    end

    it "update block_number if exist" do
      SyncInfo.create!(name: "current_block_number", value: 0)
      SyncInfo.current_block_number = value
      expect(SyncInfo.current_block_number).to eq value
    end
  end

  context "meta_data" do
    before do
      mock_get_meta_data
    end

    let(:name) { "meta_data" }
    let(:chain_id) { 1 }
    let(:chain_name) { "test-chain" }

    it "no data before" do
      expect(SyncInfo.find_by name: name).to be nil

      expect(SyncInfo.meta_data["chainId"]).to eq chain_id
    end

    it "have data before" do
      SyncInfo.meta_data
      expect(SyncInfo.meta_data["chainId"]).to eq chain_id
    end

    context "chain_id" do
      it "success" do
        expect(SyncInfo.chain_id).to eq chain_id
        expect($rebirth_chain_id).to eq chain_id
      end
    end

    context "chain_name" do
      it "success" do
        expect(SyncInfo.chain_name).to eq chain_name
        expect($rebirth_chain_name).to eq chain_name
      end
    end
  end

end
