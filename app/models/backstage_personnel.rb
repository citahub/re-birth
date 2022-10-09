class BackstagePersonnel < ApplicationRecord
  self.primary_key = %i(system_id address)

  def self.save_backstage_personnel(log, decode_tx)
    personnel = BackstagePersonnel.find_or_initialize_by(system_id: log["info"]["systemId"], address: log["info"]["account"])
    personnel.aes_data = log["info"]["data"]
    personnel.extra_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["data"], log["info"]["systemId"]).to_s)
    personnel.operator_type = log["info"]["operatorType"]
    personnel.is_active = log["info"]["setup"]

    personnel.save!
  rescue ActiveRecord::RecordNotUnique => e
    retry
  end
end
