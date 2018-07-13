class Block < ApplicationRecord
  has_one :meta_data
  has_many :transactions

  # store_accessor :header, :number
  store_accessor :body, :transactions

  validates :cita_hash, presence: true, uniqueness: true
  validates :block_number, presence: true, uniqueness: true

  store_accessor :header, :timestamp

  # current block number
  def self.current_block_number
    Block.order(block_number: :desc).first&.block_number
  end
end
