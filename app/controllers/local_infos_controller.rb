class LocalInfosController
  class << self

    def get_block_by_number(params)
      block_number_hex, flag = params
      block_number = CitaSync::Basic.hex_str_to_number(block_number_hex)
      block = Block.find_by(block_number: block_number)
      return nil if block.nil?
      # BlockSerializer.new(block).as_json
      ActiveModelSerializers::SerializableResource.new(block, serializer: ::BlockSerializer, flag: flag)
    end

    def get_transaction(params)
      hash, = params
      transaction = Transaction.find_by(cita_hash: hash)
      return nil if transaction.nil?
      # TransactionSerializer.new(transaction).as_json
      ActiveModelSerializers::SerializableResource.new(transaction, serializer: ::TransactionSerializer)
    end

    def get_meta_data(params)
      block_number_hex, = params
      block_number = CitaSync::Basic.hex_str_to_number(block_number_hex)
      meta_data = MetaData.find_by(block_number: block_number)
      return nil if meta_data.nil?
      # MetaDataSerializer.new(meta_data, key_transform: :camel_lower).as_json
      ActiveModelSerializers::SerializableResource.new(meta_data, serializer: ::MetaDataSerializer)
    end

    def get_balance(params)
      address, block_number_hex = params
      address_downcase = address.downcase
      block_number = CitaSync::Basic.hex_str_to_number(block_number_hex)
      balance = Balance.find_by(address: address_downcase, block_number: block_number)
      balance&.value
    end

    def get_abi(params)
      address, block_number_hex = params
      address_downcase = address.downcase
      block_number = CitaSync::Basic.hex_str_to_number(block_number_hex)
      abi = Abi.find_by(address: address_downcase, block_number: block_number)
      abi&.value
    end

  end

end
