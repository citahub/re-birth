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
end
