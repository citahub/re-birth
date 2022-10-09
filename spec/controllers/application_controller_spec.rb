require 'rails_helper'

RSpec.describe ApplicationController, type: :request do
  let(:body) { Oj.load(response.body) }

  context "not found" do
    it "demo" do
      post '/hhh'

      expect(response).to have_http_status(404)
      expect(body["message"]).to eq "not found"
    end
  end
end
