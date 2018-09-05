class HexUtils
  class << self
    # convert decimal number to hex string with "0x" prefix
    #
    # @param number [Integer]
    # @return [String]
    def to_hex(number)
      "0x" + number.to_s(16)
    end

    # convert hex string to decimal number
    #
    # @param str [String] hex string
    # @return [Integer] decimal number
    def to_decimal(str)
      str&.hex
    end
  end
end
