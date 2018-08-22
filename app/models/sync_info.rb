class SyncInfo < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  # get current block number
  #
  # @return [Integer, nil]
  def self.current_block_number
    SyncInfo.find_by(name: "current_block_number")&.value
  end

  # set current block number
  #
  # @param block_number [Integer]
  # @return [SyncInfo]
  def self.current_block_number=(block_number)
    sync_info = SyncInfo.find_by(name: "current_block_number")
    if sync_info.nil?
      SyncInfo.create(name: "current_block_number", value: block_number)
    else
      sync_info.update(value: block_number)
    end
  end
end
