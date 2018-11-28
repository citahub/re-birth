# frozen_string_literal: true

class Message
  attr_reader :unverified_transaction, :data, :signature, :value, :to, :from, :version, :chain_id

  # initialize the object and values...
  #
  # @param content [String] hex number string of transaction content
  # @return [void]
  def initialize(content)
    @data = AppChain::TransactionSigner.decode(content)
    @unverified_transaction = @data[:unverified_transaction]
    @transaction = @unverified_transaction[:transaction]
    @from = @data.dig(:sender, :address)
    @to = @transaction[:to]
    @data = @transaction[:data]
    @value = @transaction[:value]
    @version = @transaction[:version]
    @chain_id = @transaction[:chain_id]
    @signature = @unverified_transaction[:signature]
  end
end
