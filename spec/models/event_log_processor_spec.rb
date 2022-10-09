require 'rails_helper'

RSpec.describe EventLogProcessor do
  def connection
    ApplicationRecord.connection
  end

  before do
    allow(File).to receive(:read).and_return(file)
    mock_event_logs
  end

  after do
    processor.send :drop_table
  end

  let(:file) { File.read(Rails.root.join("spec", "config", "customs", "contracts.yml")) }
  let(:yaml) { YAML.load(file).with_indifferent_access }
  let(:file_name) { "contracts" }
  let(:file_name_with_suffix) { "#{file_name}.yml" }
  let(:processor) { EventLogProcessor.new(file_name) }
  let(:columns) { yaml[:columns] << %w(varchar blockNumber) << %w(integer blockNumberInDecimal) }
  let(:real_table_name) { "event_log_contracts" }
  let(:log) { contracts_result_one }

  it "check table prefix" do
    expect(EventLogProcessor::TABLE_PREFIX).to eq "event_log_"
  end

  context "initialize" do
    it "check attrs" do
      expect(processor.file_name).to eq file_name_with_suffix
      expect(processor.table_name).to eq file_name
      expect(processor.model_name).to eq "Contract"
      expect(processor.columns).to match_array(columns)
      expect(processor.real_table_name).to eq "event_log_contracts"
    end
  end

  context "create_table" do
    it "create success" do
      processor.create_table
      expect(ApplicationRecord.connection.table_exists?(real_table_name)).to be true
    end

    it "raise error if table already exists" do
      processor.create_table
      expect {
        processor.create_table
      }.to raise_error("table already exists")
    end

    it "check table columns" do
      expected_columns = %w(id created_at updated_at transactionHash blockNumber data blockHash transaction_index blockNumberInDecimal sender text time)

      processor.create_table

      expect(connection.columns(real_table_name).map(&:name)).to match_array(expected_columns)
    end
  end

  context "get_logs" do
    it "get from 0x0 for beginning" do
      processor.create_table
      expect(processor.get_logs["result"].count).to eq 2
    end
  end

  context "result" do
    it "extract result from get_logs" do
      processor.create_table
      expect(processor.result.count).to eq 2
    end
  end

  context "get_current_block_number" do
    it "return nil if no data" do
      processor.create_table
      expect(processor.send :get_current_block_number).to be nil
    end

    it "return the biggest blockNumberInDecimal" do
      processor.create_table

      (12000..12010).to_a.shuffle.each do |num|
        processor.get_model.create(transactionHash: num.to_s, blockNumberInDecimal: num)
      end
      expect(processor.send :get_current_block_number).to eq 12010
    end
  end

  context "decode_log" do
    it "decode success" do
      expected_decoded_logs = ["46a23e25df9a0f6c18729dda9ad1af3b6a131160", "hello world at 1535444344767", 1535444344767]
      expect(processor.decode_log(log).map {|n| n["decoded_data"]}).to match_array expected_decoded_logs
    end
  end

  context "save event log" do
    it "save two" do
      # create table first
      processor.create_table

      processor.save_event_log

      expect(processor.get_model.count).to eq 2
    end

    it "run again still have two" do
      processor.create_table

      processor.save_event_log
      processor.save_event_log

      expect(processor.get_model.count).to eq 2
    end
  end

  context "get model" do
    it "have table" do
      processor.create_table
      expect(processor.get_model).to eq EventLogProcessor::Customs::Contract
    end
  end

  context "get decode columns" do
    it "get columns" do
      decode_columns = processor.send :get_decode_columns
      expected_columns = [%w(varchar sender), %w(varchar text), %w(bigint time)]

      expect(decode_columns).to match_array(expected_columns)
    end

    it "less of column_types" do
      column_types = yaml.dig :decode, :column_types
      yaml[:decode][:column_types] = column_types[0..1]

      allow(processor).to receive(:config).and_return(yaml)

      expect {
        processor.send :get_decode_columns
      }.to raise_error("decode names length not equals to decode column_names")
    end

    it "less of names" do
      names = yaml.dig :decode, :names
      yaml[:decode][:names] = names[0..1]

      allow(processor).to receive(:config).and_return(yaml)

      expect {
        processor.send :get_decode_columns
      }.to raise_error("decode names length not equals to decode column_names")
    end
  end

  context "get decode attrs" do
    it "parse success" do
      expected = {
        sender: "46a23e25df9a0f6c18729dda9ad1af3b6a131160",
        text: "hello world at 1535444344767",
        time: 1535444344767
      }.with_indifferent_access

      expect(processor.send(:get_decode_attrs, log).with_indifferent_access).to eq expected
    end
  end

end
