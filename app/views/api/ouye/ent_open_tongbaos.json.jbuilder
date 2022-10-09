json.count @tongbaos.total_count
json.total_pages @tongbaos.total_pages
json.data @tongbaos do |open_tongbao|
  json.tongbao_id open_tongbao.tongbao_id
  json.apply_ent_id open_tongbao.apply_enterprise_id
  json.apply_ent_name open_tongbao.apply_ent.ent_name
  json.apply_operator_id open_tongbao.apply_operator.try(:operator_id)
  json.receive_ent_id open_tongbao.receive_enterprise_id
  json.receive_ent_name open_tongbao.receive_ent.ent_name
  json.open_amount open_tongbao.creditor_rights_amount.to_6
  json.hold_id open_tongbao.hold_transfer_tb_id
  json.redeem_time open_tongbao.payment_date.try(:timestamp_to_time)
  json.status open_tongbao.status
end
