require 'rails_helper'

RSpec.describe Api::SyncErrorsController, type: :controller do
  let(:result) { Oj.load(response.body).with_indifferent_access[:result] }

  before do
    20.times do
      create :sync_error
    end
  end

  context "index" do
    it "success" do
      post :index

      expect(result["count"]).to eq 20
      expect(result["syncErrors"]).to be_a(Array)
      sync_error = SyncError.last
      sync_error_resp = result["syncErrors"].first
      expect(sync_error_resp["params"]).to eq sync_error.params
      expect(sync_error_resp["method"]).to eq sync_error.method
      expect(sync_error_resp["code"]).to eq sync_error.code
      expect(sync_error_resp["message"]).to eq sync_error.message
    end

    it "with page and perPage" do
      post :index, params: { page: 1, perPage: 2 }

      expect(result["count"]).to eq 20
      expect(result["syncErrors"].count).to eq 2
    end

    it "with offset and limit" do
      post :index, params: { offset: 0, limit: 3 }

      expect(result["count"]).to eq 20
      expect(result["syncErrors"].count).to eq 3
    end
  end
end
