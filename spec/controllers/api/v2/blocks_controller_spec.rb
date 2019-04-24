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
        numberFrom: 0,
        numberTo: 10,
        transactionFrom: 20,
        transactionTo: 30,
        page: 40,
        perPage: 50,
        offset: 60,
        limit: 70
      })
    end

    let(:transformed_params) do
      ActionController::Parameters.new({
        number_from: 0,
        number_to: 10,
        transaction_from: 20,
        transaction_to: 30,
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
