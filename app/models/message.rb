require "blockchain_pb"
require "ciri/utils"
require "ciri/crypto"

class Message
  attr_reader :original_data, :original_signature
  attr_reader :data, :signature, :value, :to, :from

  def initialize(content)
    @unverified_transaction = decode(content)

    @original_data = @unverified_transaction["transaction"]["data"]
    @original_signature = @unverified_transaction["signature"]

    @data = to_hex(@original_data)
    @signature = to_hex(@original_signature)

    @value = to_hex(@unverified_transaction["transaction"]["value"])
    @to = "0x" + @unverified_transaction["transaction"]["to"]

    @from = get_from
  end

  # decode
  def decode(content)
    binary_str = hex_to_binary_str(content)
    ::UnverifiedTransaction.decode(binary_str)
  end

  def get_from
    digest_data = Ciri::Utils.sha3(@original_data)
    pubkey = Ciri::Crypto.ecdsa_recover(digest_data, @original_signature)
    # address = Ciri::Utils.sha3(pubkey[1..-1]).unpack("H*").first.downcase[-40..-1]
    address = Ciri::Utils.sha3(pubkey[1..-1])[-20..-1]
    Ciri::Utils.to_hex(address)
  end

  def to_hex(hex)
    str = hex.unpack("H*").first
    return str if str.downcase.start_with?("0x")
    "0x" + str
  end

  # remove 0x with hex string
  def filter_hex_str(hex)
    return hex[2..-1] if hex.start_with?("0x")
    hex
  end

  def hex_to_buffer(hex)
    hex_str = filter_hex_str(hex)
    [hex_str].pack('H*').bytes.to_a
  end

  # deserialization
  def hex_to_binary_str(hex)
    hex_to_buffer(hex).pack("c*")
  end

end
