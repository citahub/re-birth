class EventLogProcess
  attr_reader :config, :table_name, :model_name, :columns, :file_name

  # sync all event logs
  def self.sync_all
    EventLog.distinct.pluck(:name).each do |n|
      EventLogProcess.new(n).save_event_log
    end
  end

  # read file and initialize
  #
  # @param file [String] file name
  # @return [void]
  def initialize(file)
    @file_name = file
    @config = YAML.load(File.read(Rails.root.join("config", "customs", file))).with_indifferent_access
    @table_name = config[:table_name]
    @model_name = table_name.camelcase.singularize
    @columns = config[:columns]
    th_column = %w(string transactionHash)
    @columns << th_column unless columns.include?(th_column)
    bn_column = %w(string blockNumber)
    @columns << bn_column unless columns.include?(bn_column)
    EventLog.create(name: file)
  end

  # get logs from chain
  #
  # @return [Hash] response body
  def get_logs
    from_block = EventLog.find_by(name: file_name)&.block_number || "0x0"
    filter = { fromBlock: from_block }
    address = config[:address]
    topics = config[:topics]
    filter.merge!(address: address) unless address.blank?
    filter.merge!(topics: topics) unless topics.nil? || topics.empty?
    CitaSync::Api.get_logs(filter)
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
    # log = {
    #   "address" => "0x35bd452c37d28beca42097cfd8ba671c8dd430a1",
    #   "topics" => [
    #     "0xe4af93ca7e370881e6f1b57272e42a3d851d3cc6d951b4f4d2e7a963914468a2",
    #     "0x000000000000000000000000000000000000000000000000000001657f9d5fbf"
    #   ],
    #   "data" => "0x00000000000000000000000046a23e25df9a0f6c18729dda9ad1af3b6a1311600000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000001c68656c6c6f20776f726c64206174203135333534343433343437363700000000",
    #   "blockHash" => "0x2bb2dab1bc4e332ca61fe15febf06a1fd09738d6304d76c5dd9b57cb46880e28",
    #   "blockNumber" => "0xf11e2",
    #   "transactionHash" => "0x2c12c54a55428b56fd35b5882d5087d6cf2e20a410dc3a1b6515c2ecc3f53f22",
    #   "transactionIndex" => "0x0",
    #   "logIndex" => "0x0",
    #   "transactionLogIndex" => "0x0"
    # }.with_indifferent_access

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
  def save_event_log
    reference = columns.map { |col| [col.second, col.third] }.each { |col| col[1] = col.first if col.last.nil? }.to_h.invert

    result.each do |log|
      attrs = log.slice(*reference.keys).transform_keys { |k| reference[k] }.merge(get_decode_attrs(log.with_indifferent_access))
      ApplicationRecord.transaction do
        "Customs::#{model_name}".constantize.create(attrs)
        event_log = EventLog.find_by(name: file_name)
        event_log&.update(block_number: attrs["blockNumber"])
      end
    end
  end

  # generate model and migration
  def generate_model
    content = <<-MODEL
class Customs::#{model_name} < ApplicationRecord
  self.table_name = "#{table_name}"
  validates :transactionHash, uniqueness: true
end
    MODEL

    file_name = "#{model_name.underscore}.rb"
    file_path = Rails.root.join("app", "models", "customs", file_name)

    if File.exist?(file_path)
      raise "model already exist !"
    end

    generate_migration

    File.open(file_path, "w") { |file| file.write(content) }
  end

  # generate a migration file to db/migrate
  private def generate_migration
    migration = <<-MIGRATION
class CreateCustoms#{table_name.camelcase} < ActiveRecord::Migration[5.2]
  def change
    create_table :#{table_name} do |t|
      #{columns.map { |col| "t.#{col.first} :#{col.second}" }.join("\n      ")}
      #{get_decode_columns&.map { |col| "t.#{col.first} :#{col.second}" }&.join("\n      ")}          
      t.timestamps
    end
  end
end
    MIGRATION

    # create a migration file
    timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
    base_file_name = "create_customs_#{table_name}.rb"
    file_name = "#{timestamp}_#{base_file_name}"
    file_path = Rails.root.join("db", "migrate", file_name)
    # check file exist
    unless Dir[Rails.root.join("db", "migrate", "*.rb")].select { |f| f.end_with?(base_file_name) }.empty?
      raise "table already exist !"
    end
    # check file exist
    File.open(file_path, "w") { |file| file.write(migration) }
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

end
