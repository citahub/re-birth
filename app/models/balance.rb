# frozen_string_literal: true

class Balance < ApplicationRecord
  validates :address, presence: true
end
