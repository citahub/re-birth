require 'rails_helper'

RSpec.describe Block, type: :model do
  context "validates" do
    let(:block) { build :block }
    let(:cita_hash) { "0x" + SecureRandom.hex(32) }
    let(:new_cita_hash) { "0x" + SecureRandom.hex(32) }
    let(:block_number) { 0 }
    let(:new_block_number) { 1 }

    it "should be valid" do
      expect(block).to be_valid
    end

    it "cita_hash must be present" do
      block.cita_hash = nil

      expect(block).to be_invalid
    end

    it "cita_hash must be unique" do
      block = create :block, cita_hash: cita_hash, block_number: block_number
      valid_block = build :block, cita_hash: new_cita_hash, block_number: new_block_number
      expect(valid_block).to be_valid
      invalid_block = build :block, cita_hash: cita_hash, block_number: new_block_number
      expect(invalid_block).to be_invalid
    end

    it "block_number must be present" do
      block.block_number = nil

      expect(block).to be_invalid
    end

    it "block_number must be unique" do
      block = create :block, cita_hash: cita_hash, block_number: block_number
      valid_block = build :block, cita_hash: new_cita_hash, block_number: new_block_number
      expect(valid_block).to be_valid
      invalid_block = build :block, cita_hash: new_cita_hash, block_number: block_number
      expect(invalid_block).to be_invalid
    end
  end

  context "current block number" do
    it "no blocks should get nil" do
      expect(Block.count).to be_zero
      expect(Block.current_block_number).to be_nil
    end

    it "should get last block's number" do
      block = create :block
      expect(Block.current_block_number).to eq block.block_number
    end
  end

  context "after create" do
    context "increase_validator_count" do
      it "not cache if block_number.zero?" do
        block = create :block_zero, block_number: 0
        proposer = block.header['proposer']
        expect(proposer.blank?).not_to be true
        expect(ValidatorCache.exists?(name: proposer)).to be false
      end

      it "cache if block_number not eq zero" do
        block = create :block_one, block_number: 1
        proposer = block.header["proposer"]
        expect(proposer.blank?).not_to be true
        expect(ValidatorCache.find_by(name: proposer).counter).to eq 1
      end
    end
  end
end
