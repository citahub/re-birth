totalcount = DecodeTransaction.count
current_index = 0
DecodeTransaction.order(:block_number, :tx_index).find_each do |decode_tx|
  BuildStorageWorker.new.perform(decode_tx.tx_hash)
  puts "#{current_index += 1}/#{totalcount}"
end