# frozen_string_literal: true

class Abi < ApplicationRecord
  validates :address, presence: true
end
