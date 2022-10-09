require 'rails_helper'

RSpec.describe ValidatorCache, type: :model do
  let(:proposer) { attributes_for(:validator_cache)[:name] }

  context "increase" do
    it "counter be 1 if not exist" do
      expect(ValidatorCache.exists?(name: proposer)).to be false
      expect {
        ValidatorCache.increase(proposer)
      }.to change { ValidatorCache.count }.by(1)
      cache = ValidatorCache.find_by(name: proposer)
      expect(cache.counter).to eq 1
    end

    it "counter add 1 if exist" do
      counter = 5
      create :validator_cache, counter: counter
      expect {
        ValidatorCache.increase(proposer)
      }.to change { ValidatorCache.count }.by(0)
      cache = ValidatorCache.find_by(name: proposer)
      expect(cache.counter).to eq (counter + 1)
    end
  end
end
