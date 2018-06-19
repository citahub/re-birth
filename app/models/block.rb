class Block < ApplicationRecord
  has_many :transactions

  # store_accessor :header, :number
  store_accessor :body, :transactions

  validates :cita_hash, presence: true, uniqueness: true
  validates :block_number, presence: true, uniqueness: true
end
