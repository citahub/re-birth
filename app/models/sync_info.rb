# frozen_string_literal: true

# rubocop:disable Style/GlobalVars
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

  # get meta_data
  #
  # @return [Hash] Hash of mata_data
  def self.meta_data
    name = "meta_data"
    meta_data = find_by(name: name)
    if meta_data.nil?
      result = CitaSync::Api.get_meta_data("latest")["result"]
      meta_data = create(name: name, value: result)
    end
    meta_data.value
  end

  # get chain id
  #
  # @return [Integer]
  def self.chain_id
    $rebirth_chain_id ||= meta_data["chainId"]
  end

  # get chain name
  #
  # @return [String]
  def self.chain_name
    $rebirth_chain_name ||= meta_data["chainName"]
  end
end
# rubocop:enable Style/GlobalVars
