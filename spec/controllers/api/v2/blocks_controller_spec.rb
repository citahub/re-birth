require 'rails_helper'

RSpec.describe Api::V2::BlocksController, type: :controller do

  before do
    create :block_zero
    create :block_one
  end

  let(:result) { Oj.load(response.body).with_indifferent_access[:result] }
  let(:count) { result[:blocks].size }

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

    it "with numberFrom" do
      post :index, params: { numberFrom: 1 }
      expect(count).to eq 1
    end

    it "with numberTo" do
      post :index, params: { numberTo: 0 }
      expect(count).to eq 1
    end

    it "with numberFrom and NumberTo" do
      post :index, params: { numberFrom: 2, numberTo: 1 }
      expect(count).to eq 0
    end

    it "with transactionFrom" do
      post :index, params: { transactionFrom: 1 }
      expect(count).to eq 1
    end

    it "with transactionTo" do
      post :index, params: { transactionTo: 0 }
      expect(count).to eq 1
    end

    it "with transactionFrom and transactionTo" do
      post :index, params: { transactionFrom: 1, transactionTo: 1 }
      expect(count).to eq 1
    end

  end
end
