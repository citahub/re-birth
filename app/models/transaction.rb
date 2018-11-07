# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :block, optional: true
  has_many :event_logs
  has_many :erc20_transfers

  delegate :timestamp, to: :block, allow_nil: true

  # validates :block, presence: true
  validates :cita_hash, presence: true, uniqueness: true

  alias_attribute :gas_used, :quota_used
end
