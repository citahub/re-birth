# frozen_string_literal: true

require "blockchain_pb"
require "ciri/utils"
require "ciri/crypto"

class Message
  attr_reader :original_data, :original_signature, :unverified_transaction
  attr_reader :data, :signature, :value, :to, :from, :version, :chain_id

  # initialize the object and values...
  #
  # @param content [String] hex number string of transaction content
  # @return [void]
  def initialize(content)
    @unverified_transaction = decode(content)

    @original_data = @unverified_transaction["transaction"]["data"]
    @original_signature = @unverified_transaction["signature"]

    @data = to_hex(@original_data)
    @signature = to_hex(@original_signature)

    @version = @unverified_transaction["transaction"]["version"]

    @value = to_hex(@unverified_transaction["transaction"]["value"])
    @to = "0x" + if @version.zero?
                   @unverified_transaction["transaction"]["to"]
                 elsif @version == 1
                   @unverified_transaction["transaction"]["to_v1"]&.unpack1("H*")
                 else
                   ""
                 end

    @chain_id = if @version.zero?
                  @unverified_transaction["transaction"]["chain_id"]
                elsif @version == 1
                  chain_id_v1 = @unverified_transaction["transaction"]["chain_id_v1"]&.unpack1("H*")
                  "0x#{chain_id_v1}"
                end

    @from = get_from
  end

  # unserialize the transaction content
  #
  # @param content [String] hex number string of transaction content
  # @return [UnverifiedTransaction] an object of google protobuf file in lib dir.
  def decode(content)
    binary_str = hex_to_binary_str(content)
    ::UnverifiedTransaction.decode(binary_str)
  end

  # get from value from UnverifiedTransaction
  # @return [String] an address of hex number string with prefix "0x"
  def get_from
    transaction = unverified_transaction["transaction"]
    msg = ProtoTransaction.encode(transaction)
    tx_msg = Ciri::Utils.keccak(msg)
    pubkey = Ciri::Crypto.ecdsa_recover(tx_msg, @original_signature)
    address = Ciri::Utils.keccak(pubkey[1..-1])[-20..-1]
    Ciri::Utils.to_hex(address)
  end

  # a method to convert hex byte string to hex number string with prefix "0x"
  # @return [String] an hex string of address
  def to_hex(hex)
    str = hex.unpack1("H*")
    return str if str.downcase.start_with?("0x")

    "0x" + str
  end

  # remove "0x" prefix if have
  #
  # @param [String] hex number string
  # @return [String]
  def filter_hex_str(hex)
    return hex[2..-1] if hex.start_with?("0x")

    hex
  end

  # convert hex string to byte code array
  #
  # @param hex [String] hex number string
  # @return [Array<Integer>] byte code array
  def hex_to_buffer(hex)
    hex_str = filter_hex_str(hex)
    [hex_str].pack("H*").bytes.to_a
  end

  # convert hex string to binary string
  #
  # @param hex [String] hex number string
  # @return [String] binary string
  def hex_to_binary_str(hex)
    hex_to_buffer(hex).pack("c*")
  end
end
