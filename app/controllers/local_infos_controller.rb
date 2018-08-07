class LocalInfosController
  class << self

    # find a block in db with rpc params, getBlockByNumber method.
    #
    # @param params [[String, Boolean]] rpc interface params, hex number string and with transaction or not.
    # @return [ActiveModelSerializers::SerializableResource, nil] BlockSerializer, return nil if not found.
    def get_block_by_number(params)
      block_number_hex, flag = params
      block_number = HexUtils.to_decimal(block_number_hex)
      block = Block.find_by(block_number: block_number)
      return nil if block.nil?
      # BlockSerializer.new(block).as_json
      ActiveModelSerializers::SerializableResource.new(block, serializer: ::BlockSerializer, flag: flag)
    end

    # find a block in db with rpc params, getBlockByHash method.
    #
    # @param params [[String, Boolean]] rpc interface params, block hash and with transaction or not.
    # @return [ActiveModelSerializers::SerializableResource, nil] BlockSerializer, return nil if not found.
    def get_block_by_hash(params)
      hash, flag = params
      block = Block.find_by(cita_hash: hash)
      return nil if block.nil?
      ActiveModelSerializers::SerializableResource.new(block, serializer: ::BlockSerializer, flag: flag)
    end

    # find a transaction in db with rpc params, getTransaction method.
    #
    # @param params [[String]] rpc interface params, transaction hash.
    # @return [ActiveModelSerializers::SerializableResource, nil] TransactionSerializer, return nil if not found.
    def get_transaction(params)
      hash, = params
      transaction = Transaction.find_by(cita_hash: hash)
      return nil if transaction.nil?
      # TransactionSerializer.new(transaction).as_json
      ActiveModelSerializers::SerializableResource.new(transaction, serializer: ::TransactionSerializer)
    end

    # find a transaction in db with rpc params, getMetaData method.
    #
    # @param params [[String]] rpc interface params, block number of hex string.
    # @return [ActiveModelSerializers::SerializableResource, nil] MetaDataSerializer, return nil if not found.
    def get_meta_data(params)
      block_number_hex, = params
      block_number = HexUtils.to_decimal(block_number_hex)
      meta_data = MetaData.find_by(block_number: block_number)
      return nil if meta_data.nil?
      # MetaDataSerializer.new(meta_data, key_transform: :camel_lower).as_json
      ActiveModelSerializers::SerializableResource.new(meta_data, serializer: ::MetaDataSerializer)
    end

    # find a balance in db with rpc params, getBalance method.
    #
    # @param params [[String, String]] rpc interface params, address and block number of hex string.
    # @return [String] hex string of balance
    def get_balance(params)
      address, block_number_hex = params
      address_downcase = address.downcase
      block_number = HexUtils.to_decimal(block_number_hex)
      balance = Balance.find_by(address: address_downcase, block_number: block_number)
      balance&.value
    end

    # find an abi in db with rpc params, getAbi method.
    #
    # @param params[[String, String]] rpc interface params, address and block number of hex string.
    # @return [String] hex string of abi
    def get_abi(params)
      address, block_number_hex = params
      address_downcase = address.downcase
      block_number = HexUtils.to_decimal(block_number_hex)
      abi = Abi.find_by(address: address_downcase, block_number: block_number)
      abi&.value
    end

  end

end
