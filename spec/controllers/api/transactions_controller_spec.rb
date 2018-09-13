require 'rails_helper'

def random(num)
  "0x" + SecureRandom.hex(num)
end

RSpec.describe Api::TransactionsController, type: :controller do
  let(:from) { random(20) }
  let(:to) { random(20) }

  let(:result) { Oj.load(response.body).with_indifferent_access[:result] }
  let(:count) { result[:count] }

  before do
    block_one = create :block_one
    13.times do
      create :transaction, block: block_one, cita_hash: random(32)
    end

    create :transaction, block: block_one, cita_hash: random(32), from: from
    create :transaction, block: block_one, cita_hash: random(32), to: to
  end

  context "index" do
    it "no params" do
      post :index, params: {}
      expect(count).to eq 15
    end

    context "with account" do
      it "equal to from" do
        post :index, params: { account: from }
        expect(count).to eq 1
      end

      it "equal to to" do
        post :index, params: { account: to }
        expect(count).to eq 1
      end
    end

    it "with from" do
      post :index, params: { from: from }
      expect(count).to eq 1
    end

    it "with to" do
      post :index, params: { to: to }
      expect(count).to eq 1
    end

    context "ignore case" do
      let(:swapcase_from) { from.swapcase }
      let(:swapcase_to) { to.swapcase }

      it "with swapcase from" do
        post :index, params: { from: swapcase_from }
        expect(count).to eq 1
      end

      it "with swapcase to" do
        post :index, params: { to: swapcase_to }
        expect(count).to eq 1
      end

      it "with swapcase account" do
        post :index, params: { account: swapcase_from }
        expect(count).to eq 1
      end
    end

    it "with page and perPage" do
      post :index, params: { page: 2, perPage: 10 }
      expect(count).to eq 15
      expect(result[:transactions].count).to eq 5
    end

    it "with offset and limit" do
      post :index, params: { offset: 10, limit: 10 }
      expect(count).to eq 15
      expect(result[:transactions].count).to eq 5
    end

    it "with offset" do
      post :index, params: { offset: 0 }
      expect(count).to eq 15
      expect(result[:transactions].count).to eq 10
    end

    it "with limit" do
      post :index, params: { limit: 5 }
      expect(count).to eq 15
      expect(result[:transactions].count).to eq 5
    end

    context "with valueFormat" do
      let(:value_hex) { attributes_for(:transaction)[:value] }
      let(:value_decimal) { HexUtils.to_decimal(value_hex) }
      it "return decimal if valueFormat equals decimal" do
        get :index, params: { valueFormat: "decimal" }

        expect(result["transactions"].map {|n| n["value"]}.uniq).to match_array [value_decimal]
      end

      it "return hex if valueFormat equals hex" do
        get :index, params: { valueFormat: 'hex' }

        expect(result["transactions"].map {|n| n["value"]}.uniq).to match_array [value_hex]
      end

      it "return hex if valueFormat not set" do
        get :index

        expect(result["transactions"].map {|n| n["value"]}.uniq).to match_array [value_hex]
      end
    end
  end
end
