# frozen_string_literal: true

class ValidatorCache < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  # increase a validator's count
  #
  # @param name [String] Block header proposer
  # @return [void]
  def self.increase(name)
    # add transaction for lock cache
    ApplicationRecord.transaction do
      return if name.blank?

      cache = ValidatorCache.find_by(name: name)
      if cache.nil?
        ValidatorCache.create(name: name, counter: 1)
      else
        # lock it
        cache.lock!
        cache.update!(counter: cache.counter + 1)
      end
    end
  end
end
