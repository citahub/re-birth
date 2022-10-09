class Institution < ApplicationRecord
  self.primary_key = %i(system_id institutions_id)

  has_many :open_tongbaos, foreign_key: %i(system_id create_enterprise_id), class_name: "OpenTongbao"

  before_save :update_ent_id_and_name

  def update_ent_id_and_name
    if self.extra_data_changed? && self.extra_data.present?
      self.ent_name = extra_data.to_h["entName"]
    end
  end

  def opening_amount
    self.open_tongbaos.applying.sum(:creditor_rights_amount)
  end

  def used_amount
    self.open_tongbaos.where(redeem_time: nil, received: true).sum(:creditor_rights_amount)
  end

  def children_lock_amount
    self.lock_credit.to_i - self.open_tongbaos.applying.where(enterprise_time: nil, is_quick: nil).sum(:creditor_rights_amount)
  end

  def usable_amount
    self.credit_limit.to_i - self.credit_spent.to_i - self.lock_credit.to_i
  end

  def self.save_institution(log, decode_tx)
    case log["abi"]["name"]
    when "InstitutionsInfo"
      institution = Institution.find_or_initialize_by(system_id: log["info"]["systemId"], institutions_id: log["info"]["institutionsId"])
      institution.aes_data = log["info"]["data"]
      institution.extra_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["data"], log["info"]["systemId"]).to_s) unless decode_tx.auth_mode?
      institution.parent_ent_id = log["info"]["parentEntId"]
      institution.financial_code = log["info"]["financialCode"]
      institution.is_independent = log["info"]["isIndependent"]
      institution.is_core_enterprise = log["info"]["isCoreEnterprise"]
      institution.open_limit = log["info"]["institutionsAmount"]
    when "RightsInfo"
      institution = Institution.find_or_initialize_by(system_id: log["info"]["systemId"], institutions_id: log["info"]["institutionsId"])
      institution.credit_aes_data = log["info"]["data"]
      institution.credit_extra_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["data"], log["info"]["systemId"]).to_s) unless decode_tx.auth_mode?
      institution.credit_type = log["info"]["creditType"]
      institution.credit_limit = log["info"]["creditLimit"]
      institution.credit_start_time = log["info"]["creditStartTime"]
      institution.credit_end_time = log["info"]["creditEndTime"]
    when "RightsFreezeInfo"
      institution = Institution.find_or_initialize_by(system_id: log["info"]["systemId"], institutions_id: log["info"]["institutionsId"])
      institution.freeze_aes_data = log["info"]["data"]
      institution.freeze_extra_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["data"], log["info"]["systemId"]).to_s) unless decode_tx.auth_mode?
      institution.freeze_type = log["info"]["freeze"]
    end
    institution.save!
  rescue ActiveRecord::RecordNotUnique => e
    retry
  end

  def self.save_rights_amount(log, decode_tx)
    begin
      ApplicationRecord.transaction(isolation: :serializable) do
        institution = Institution.find_or_initialize_by(system_id: log["info"]["systemId"], institutions_id: log["info"]["institutionsId"])
        return if institution.credit_block_number.to_i > decode_tx.block_number
        return if institution.credit_block_number == decode_tx.block_number && institution.credit_tx_index > decode_tx.tx_index

        institution.credit_balance = log["info"]["balance"]
        institution.credit_spent = log["info"]["spent"]
        institution.credit_arrears = log["info"]["totalArrears"]
        institution.credit_block_number = decode_tx.block_number
        institution.credit_tx_index = decode_tx.tx_index
        institution.save!
      end
    rescue ActiveRecord::SerializationFailure => e
      retry
    end
  end

end
