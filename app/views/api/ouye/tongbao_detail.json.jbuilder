json.count @tongbaos.total_count
json.total_pages @tongbaos.total_pages
json.data @tongbaos do |tongbao|
  json.transfer_no tongbao.transfer_no
  json.transfer_type tongbao.transfer_type
  json.form_ent_id tongbao.from_ent_id
  json.hold_ent_id tongbao.hold_ent_id
  json.operator_id tongbao.operator_id
  json.amount tongbao.amount.to_6
  json.transfer_time tongbao.timestamp.timestamp_to_time
end
