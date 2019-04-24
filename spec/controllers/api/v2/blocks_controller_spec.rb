require 'rails_helper'

RSpec.describe Api::V2::BlocksController, type: :controller do

  before do
    create :block_zero
    create :block_one
  end

  let(:result) { Oj.load(response.body).with_indifferent_access[:result] }
  let(:count) { result[:blocks].size }

  context "params transform" do
    let(:params) do
      ActionController::Parameters.new({
        blockNumberFrom: 0,
        blockNumberTo: 10,
        minTransactionCount: 20,
        maxTransactionCount: 30,
        page: 40,
        perPage: 50,
        offset: 60,
        limit: 70
      })
    end

    let(:transformed_params) do
      ActionController::Parameters.new({
        block_number_from: 0,
        block_number_to: 10,
        min_transaction_count: 20,
        max_transaction_count: 30,
        page: 40,
        per_page: 50,
        offset: 60,
        limit: 70
      })
    end

    it "transform underscore" do
      expect(params.transform_keys!(&:underscore)).to eq transformed_params
    end
  end

  context "index" do
    it "no params" do
      post :index, params: {}
      expect(count).to eq 2
    end

    it "with page and perPage" do
      post :index, params: { page: 1, perPage: 1 }
      expect(count).to eq 1
    end

    it "with offset and limit" do
      post :index, params: { offset: 0, limit: 1 }
      expect(count).to eq 1
    end

    it "with blockNumberFrom" do
      post :index, params: { blockNumberFrom: 1 }
      expect(count).to eq 1
    end

    it "with blockNumberTo" do
      post :index, params: { blockNumberTo: 0 }
      expect(count).to eq 1
    end

    it "with blockNumberFrom and blockNumberTo" do
      post :index, params: { blockNumberFrom: 2, blockNumberTo: 1 }
      expect(count).to eq 0
    end

    it "with minTransactionCount" do
      post :index, params: { minTransactionCount: 1 }
      expect(count).to eq 1
    end

    it "with maxTransactionCount" do
      post :index, params: { maxTransactionCount: 0 }
      expect(count).to eq 1
    end

    it "with minTransactionCount and maxTransactionCount" do
      post :index, params: { minTransactionCount: 1, maxTransactionCount: 1 }
      expect(count).to eq 1
    end

  end
end
