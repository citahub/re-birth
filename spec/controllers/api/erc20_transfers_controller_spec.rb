require 'rails_helper'

RSpec.describe Api::Erc20TransfersController, type: :controller do
  let(:body) { Oj.load(response.body).with_indifferent_access }
  let(:result) { body[:result] }
  let(:count) { result[:count] }

  let(:tx) { create :transaction }
  let(:event_log) { create :erc20_event_log, tx: tx, block: tx.block }
  let(:erc20_transfer) { create :erc20_transfer, event_log: event_log, tx: tx, block: tx.block }
  let(:transfer_attrs) { attributes_for(:erc20_transfer) }
  let(:from) { transfer_attrs[:from] }
  let(:to) { transfer_attrs[:to] }
  let(:value) { transfer_attrs[:value] }
  let(:address) { transfer_attrs[:address] }

  def get_result(response)
    Oj.load(response.body).with_indifferent_access[:result]
  end

  before do
    mock_get_meta_data
  end

  context "index" do
    context "with transfer already exist" do
      before do
        event_log
        erc20_transfer
      end

      context "no address" do
        it "return an error message" do
          get :index
          expect(body[:message]).to eq "must have address"
        end
      end

      context "only address" do
        it "one event log and transfer" do
          get :index, params: { address: address }
          expect(count).to eq 1
        end
      end

      context "with account" do
        it "equal to from" do
          get :index, params: { address: address, account: from }
          expect(count).to eq 1
        end

        it "equal to to" do
          get :index, params: { address: address, account: to }
          expect(count).to eq 1
        end

        it "not equal from or to" do
          get :index, params: { address: address, account: from + "1" }
          expect(count).to eq 0
        end
      end

      it "with from" do
        get :index, params: { address: address, from: from }
        expect(count).to eq 1
      end

      it "with to" do
        get :index, params: { address: address, to: to }
        expect(count).to eq 1
      end

      context "ignore case" do
        let(:swapcase_from) { from.swapcase }
        let(:swapcase_to) { to.swapcase }

        it "with swapcase from" do
          get :index, params: { address: address, from: swapcase_from }
          expect(count).to eq 1
        end

        it "with swapcase to" do
          get :index, params: { address: address, to: swapcase_to }
          expect(count).to eq 1
        end

        it "with swapcase account" do
          get :index, params: { address: address, account: swapcase_from }
          expect(count).to eq 1
        end
      end

      it "with page and perPage" do
        get :index, params: { address: address, page: 1, perPage: 10 }
        expect(get_result(response)[:transfers].count).to eq 1
        get :index, params: { address: address, page: 2, perPage: 10 }
        expect(get_result(response)[:transfers].count).to eq 0
      end

      it "with offset and limit" do
        get :index, params: { address: address, offset: 0, limit: 10 }
        expect(get_result(response)[:transfers].count).to eq 1
        get :index, params: { address: address, offset: 10, limit: 10 }
        expect(get_result(response)[:transfers].count).to eq 0
      end

      it "with offset" do
        get :index, params: { address: address, offset: 0 }
        expect(result[:transfers].count).to eq 1
      end

      it "with limit" do
        get :index, params: { address: address, limit: 5 }
        expect(result[:transfers].count).to eq 1
      end

    end

    context "with no event log" do
      context "only address" do
        it "no event log" do
          get :index, params: { address: address }
          expect(count).to eq 0
        end
      end
    end

    context "with one event log but no transfer" do
      before do
        event_log
      end

      context "only address" do
        it "one event log" do
          get :index, params: { address: address }
          expect(count).to eq 1
        end
      end
    end
  end
end
