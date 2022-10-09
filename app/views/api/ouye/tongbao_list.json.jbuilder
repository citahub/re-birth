json.count @tongbaos.total_count
json.total_pages @tongbaos.total_pages
json.data @tongbaos do |tongbao|
  json.ent_name tongbao.hold_ent.ent_name
  json.ent_id tongbao.hold_ent_id
  json.open_no tongbao.tongbao_id
  json.hold_no tongbao.hold_id
  json.init_amount tongbao.amount.to_6
  json.balance_amount tongbao.current_balance.to_6
  json.transfer_amount (tongbao.amount - tongbao.balance).to_6
  json.redeem_amount tongbao.redeem_amount.to_i.to_6
  json.lock_amount tongbao.lock_amount.to_i.to_6
end
