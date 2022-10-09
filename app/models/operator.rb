class Operator < ApplicationRecord
  self.primary_key = %i(system_id address)

  def self.save_institutions_operator(log, decode_tx)
    operator = Operator.find_or_initialize_by(system_id: log["info"]["systemId"], institutions_id: log["info"]["institutionsId"], address: log["info"]["account"])
    operator.aes_data = log["info"]["data"]
    operator.extra_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["data"], log["info"]["systemId"]).to_s)
    operator.is_active = log["info"]["setup"]
    operator.operator_id = operator.extra_data.to_h["operatorId"]
    operator.save!
  rescue ActiveRecord::RecordNotUnique => e
    retry
  end
end
