json.count @ents.total_count
json.total_pages @ents.total_pages
json.data @ents do |ent|
  json.ent_name ent.ent_name
  json.ent_id ent.institutions_id
  json.init_amount ent.credit_limit.to_i.to_6
  json.available_amount ent.usable_amount.to_6
  json.children_lock_amount ent.children_lock_amount.to_6
  json.start_date ent.credit_start_time&.timestamp_to_time&.to_date.to_s
  json.end_date ent.credit_end_time&.timestamp_to_time&.to_date.to_s
  json.used_amount ent.used_amount.to_6
  json.opening_amount ent.opening_amount.to_6
end
