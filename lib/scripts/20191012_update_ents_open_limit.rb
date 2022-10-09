# 修复数据开立限额数据
# docker run -it  -v `pwd`:/app data_service_app bundle exec rake db:migrate
# docker run -it  -v `pwd`:/app data_service_app rails runner lib/scripts/20191012_update_ents_open_limit.rb

Institution.where(open_limit: nil).find_each do |ent|
  decode_tx = DecodeTransaction.order(:block_number, :tx_index).where("decode_logs @> ?", [abi: {name: "InstitutionsInfo"}, info: {identityOwner: ent.address}].to_json).last
  next unless decode_tx
  decode_log = decode_tx.decode_logs.reverse.find{ |log| log["abi"]["name"] == "InstitutionsInfo" }
  puts decode_log
  ent.update_column(:open_limit, decode_log["info"]["institutionsAmount"])
end
