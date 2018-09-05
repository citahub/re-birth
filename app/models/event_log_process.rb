class EventLogProcess
  attr_reader :config, :table_name, :model_name, :columns, :file_name, :real_table_name

  # all tables add prefix with "event_log_"
  TABLE_PREFIX = "event_log_"

  # sync all event logs
  def self.sync_all
    event_tables = ApplicationRecord.connection.tables.select { |t| t.start_with?(TABLE_PREFIX) }
    event_tables.map {|n| n[10..-1]}.each do |n|
      EventLogProcess.new(n).save_event_log
    end
  end

  # read file and initialize
  #
  # @param file [String] file name
  # @return [void]
  def initialize(file)
    @file_name = "#{file}.yml"
    @config = YAML.load(File.read(Rails.root.join("config", "customs", file_name))).with_indifferent_access
    @table_name = file
    @model_name = table_name.camelcase.singularize
    @columns = config[:columns]
    # th_column = %w(varchar transactionHash)
    # @columns << th_column unless columns.include?(th_column)
    bn_column = %w(varchar blockNumber)
    @columns << bn_column unless columns.include?(bn_column)
    bn_decimal_column = %w(integer blockNumberInDecimal)
    @columns << bn_decimal_column unless columns.include?(bn_decimal_column)
    @real_table_name = TABLE_PREFIX + table_name
  end

  def create_table
    # raise error if table already exists
    raise "table already exists" if ApplicationRecord.connection.table_exists?(real_table_name)

    sql = <<~SQL
          create table if not exists #{real_table_name}
          (
            id bigserial not null constraint #{real_table_name}_pkey primary key,
            "created_at" timestamp not null,
            "updated_at" timestamp not null,
            "transactionHash" varchar not null UNIQUE,  
            #{columns.map { |col| "\"#{col.second}\" #{col.first}," }.join("\n  ")}
            #{get_decode_columns&.map { |col| "\"#{col.second}\" #{col.first}," }&.join("\n  ")}
          )
    SQL
    lines = sql.lines
    lines[-2].gsub!(/,/, '')
    sql = lines.join
    # execute to create table
    ApplicationRecord.connection.execute(sql)
  end

  # get logs from chain
  #
  # @return [Hash] response body
  def get_logs
    current_block_number = get_current_block_number
    from_block = HexUtils.to_hex(current_block_number.nil? ? 0 : current_block_number + 1)

    filter = { fromBlock: from_block }
    address = config[:address]
    topics = config[:topics]
    filter.merge!(address: address) unless address.blank?
    filter.merge!(topics: topics) unless topics.nil? || topics.empty?
    CitaSync::Api.get_logs(filter)
  end

  private def get_current_block_number
    attr_name = "blockNumberInDecimal"
    sql = %Q{ SELECT "#{attr_name}" from #{real_table_name} ORDER BY "#{attr_name}" DESC LIMIT 1 }
    first = ApplicationRecord.connection.execute(sql).to_set.first
    return if first.nil?
    first[attr_name]
  end

  # get result of `get_logs`
  def result
    get_logs["result"]
  end

  # decode one event log
  #
  # @param log [Hash] event log
  # @return [[Hash]] abi inputs with decoded_data
  def decode_log(log)
    log = log.with_indifferent_access
    decoder = Ethereum::Decoder.new

    decode_info = config[:decode]
    return if decode_info.nil?
    abi_inputs = decode_info[:abi_inputs]
    data_inputs = abi_inputs.select { |i| !i[:indexed] }
    inputs = data_inputs.map { |input| Ethereum::FunctionInput.new(input) }
    decoded_data = decoder.decode_arguments(inputs, log[:data])
    data_inputs.each_with_index { |d, i| d[:decoded_data] = decoded_data[i] }

    # topics
    topics = log[:topics]
    topic_inputs = abi_inputs.select { |i| i[:indexed] }.each_with_index do |a, i|
      a[:decoded_data] = decoder.decode(a[:type], topics[i + 1])
    end

    abi_inputs
  end

  # save all event logs by `get_logs`
  #
  # @return [void]
  def save_event_log
    dynamic_model

    reference = (columns << %w(varchar transactionHash)).map { |col| [col.second, col.third] }.each { |col| col[1] = col.first if col.last.nil? }.to_h.invert

    result.each do |log|
      block_number = log["blockNumber"]
      block_number_in_decimal = HexUtils.to_decimal(block_number)
      attrs = log.slice(*reference.keys).transform_keys { |k| reference[k] }.merge(get_decode_attrs(log.with_indifferent_access)).merge({ blockNumberInDecimal: block_number_in_decimal })
      ApplicationRecord.transaction do
        "EventLogProcess::Customs::#{model_name}".constantize.create(attrs)
        event_log = EventLog.find_by(name: file_name)
        event_log&.update(block_number: attrs["blockNumber"])
      end
    end
  end

  # return the dynamic model of this table
  def get_model
    dynamic_model
    "EventLogProcess::Customs::#{model_name}".constantize
  end

  class CustomsBaseClass < ApplicationRecord
  end
  module Customs
  end
  private def dynamic_model
    class_name = "#{model_name}"

    return if EventLogProcess::Customs.const_defined?(class_name)

    rtn = real_table_name
    klass = Class.new(CustomsBaseClass) do
      self.table_name = "#{rtn}"
    end

    Customs.const_set class_name, klass
  end

  # for generate migration
  #
  # @return [[[String, String]], nil]
  private def get_decode_columns
    column_types = config.dig :decode, :column_types
    names = config.dig :decode, :names
    return if names.nil? || column_types.nil?
    raise "decode names length not equals to decode column_names" if names.size != column_types.size
    column_types.zip(names)
  end

  # get decoded attrs (Hash)
  #
  # @param log [Hash] event log
  # @return [Hash]
  private def get_decode_attrs(log)
    decoded_data = decode_log(log).map { |dl| dl[:decoded_data] }
    names = config.dig :decode, :names
    return if names.nil? || decoded_data.nil?
    raise "decode names length not equals to inputs" if names.size != decoded_data.size
    Hash[names.zip(decoded_data)]
  end

  # helper method, mock a log
  #
  # @return [Hash] a hash of event log
  private def mock_log
    {
      "address" => "0x35bd452c37d28beca42097cfd8ba671c8dd430a1",
      "topics" => [
        "0xe4af93ca7e370881e6f1b57272e42a3d851d3cc6d951b4f4d2e7a963914468a2",
        "0x000000000000000000000000000000000000000000000000000001657f9d5fbf"
      ],
      "data" => "0x00000000000000000000000046a23e25df9a0f6c18729dda9ad1af3b6a1311600000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000001c68656c6c6f20776f726c64206174203135333534343433343437363700000000",
      "blockHash" => "0x2bb2dab1bc4e332ca61fe15febf06a1fd09738d6304d76c5dd9b57cb46880e28",
      "blockNumber" => "0xf11e2",
      "transactionHash" => "0x2c12c54a55428b56fd35b5882d5087d6cf2e20a410dc3a1b6515c2ecc3f53f22",
      "transactionIndex" => "0x0",
      "logIndex" => "0x0",
      "transactionLogIndex" => "0x0"
    }.with_indifferent_access
  end

  # helper method, use it carefully
  private def drop_table
    sql = %Q{ DROP TABLE #{real_table_name}; }
    ApplicationRecord.connection.execute(sql)
  end

end
