class OpenTongbao < ApplicationRecord
  self.primary_key = %i(system_id tongbao_id)

  has_many :tongbaos, foreign_key: %i(system_id tongbao_id), primary_key: %i(system_id tongbao_id), class_name: "Tongbao"

  belongs_to :create_ent, optional: true, foreign_key: %i(system_id create_enterprise_id), class_name: "Institution"
  belongs_to :apply_ent, optional: true, foreign_key: %i(system_id apply_enterprise_id), class_name: "Institution"
  belongs_to :receive_ent, optional: true, foreign_key: %i(system_id receive_enterprise_id), class_name: "Institution"

  has_one :hold_tongbao, primary_key: %i(system_id hold_transfer_tb_id), foreign_key: %i(system_id hold_id), class_name: "Tongbao"

  scope :applying, -> { where(platform_agreed: [true, nil], enterprise_agreed: [true, nil], receive_time: nil, cancel_time: nil, back_creditor_time: nil, refuse_time: nil) }
  scope :ended, -> { where("platform_agreed = FALSE OR enterprise_agreed = FALSE OR receive_time IS NOT NULL OR cancel_time IS NOT NULL OR back_creditor_time IS NOT NULL OR refuse_time IS NOT NULL") }


  def apply_operator
    operator_id = extra_data && extra_data["fromOperatorId"]
    return nil if operator_id.blank?
    Operator.find_by(operator_id: operator_id, system_id: system_id)
  end

  def status
    case
    when platform_agreed == false
      "平台已拒绝"
    when enterprise_agreed == false
      "复核已拒绝"
    when received == false
      "供应商拒绝"
    when cancel_time.present?
      "企业已撤销"
    when back_creditor_time.present?
      "授信已退回"
    when refuse_time.present?
      "平台已撤销"
    when !is_quick && enterprise_time.blank?
      "等待企业复核"
    when platform_time.blank?
      "等待平台审核"
    when receive_time.blank?
      "等供应商接收"
    when redeem_time.present?
      "已兑付"
    when pre_time.present?
      "已经预兑付"
    when receive_time.present?
      "供应商已接收"
    end
  end

  def self.save_open_tongbao(log, decode_tx)
    begin
      open_tongbao = OpenTongbao.find_or_initialize_by(system_id: log["info"]["systemId"], tongbao_id: log["info"]["creditorRightsNumID"])

      case log["abi"]["name"]
      when "CreateCreditorRights", "QuickCreateCreditorRights"
        open_tongbao.hold_transfer_tb_id = log["info"]["holdTransferTbId"]
        open_tongbao.aes_data = log["info"]["data"]
        open_tongbao.extra_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["data"], log["info"]["systemId"]).to_s) unless decode_tx.auth_mode?
        open_tongbao.creditor_rights_amount = log["info"]["creditorRightsAmount"]
        open_tongbao.apply_enterprise_id = log["info"]["applyEnterprise"]
        open_tongbao.create_enterprise_id = log["info"]["createEnterprise"]
        open_tongbao.receive_enterprise_id = log["info"]["receiveEnterprise"]
        open_tongbao.is_advance_charge = log["info"]["isPrePayment"]
        open_tongbao.invoice_encrypted = [log["info"]["invoice"]]
        open_tongbao.invoice_decrypted = [Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["invoice"], log["info"]["systemId"]).to_s)] unless decode_tx.auth_mode?
        open_tongbao.payment_date = log["info"]["paymentDate"]
        open_tongbao.apply_time = decode_tx.timestamp
        open_tongbao.is_quick = true if log["abi"]["name"] == "QuickCreateCreditorRights"
      when "PlatformReview"
        open_tongbao.platform_time = decode_tx.timestamp
        open_tongbao.aes_platform_data = log["info"]["data"]
        open_tongbao.extra_platform_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["data"], log["info"]["systemId"]).to_s) unless decode_tx.auth_mode?
        open_tongbao.platform_agreed = log["info"]["agreed"]
      when "EnterpriseReview"
        open_tongbao.enterprise_time = decode_tx.timestamp
        open_tongbao.aes_enterprise_data = log["info"]["data"]
        open_tongbao.extra_enterprise_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["data"], log["info"]["systemId"]).to_s) unless decode_tx.auth_mode?
        open_tongbao.enterprise_agreed = log["info"]["agreed"]
      when "ReceiveCreditorRights"
        open_tongbao.receive_time = decode_tx.timestamp
        open_tongbao.aes_receive_data = log["info"]["data"]
        open_tongbao.extra_receive_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["data"], log["info"]["systemId"]).to_s) unless decode_tx.auth_mode?
        open_tongbao.received = log["info"]["received"]
      when "CancelCreditorRights" #债权开立撤销后，需要调用平台退授信接口
        open_tongbao.cancel_time = decode_tx.timestamp
        open_tongbao.aes_cancel_data = log["info"]["data"]
        open_tongbao.extra_cancel_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["data"], log["info"]["systemId"]).to_s) unless decode_tx.auth_mode?
      when "CancelCRPlatformConfirm" # 债权开立撤销后，需要调用平台退授信接口
        open_tongbao.back_creditor_time = decode_tx.timestamp
      when "CancelCRByPlatform"
        open_tongbao.refuse_time = decode_tx.timestamp
        open_tongbao.aes_refuse_data = log["info"]["data"]
        open_tongbao.extra_refuse_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["data"], log["info"]["systemId"]).to_s) unless decode_tx.auth_mode?
      when "UpdateInvoice"
        open_tongbao.invoice_encrypted << log["info"]["invoice"]
        open_tongbao.invoice_decrypted << Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["invoice"], log["info"]["systemId"]).to_s) unless decode_tx.auth_mode?
      end

      open_tongbao.save!
    rescue ActiveRecord::RecordNotUnique => e
      retry
    end

    if log["abi"]["name"] == "ReceiveCreditorRights" && log["info"]["received"] == true
      open_tongbao.reload
      begin
        ApplicationRecord.transaction(isolation: :serializable) do
          Tongbao.create!(
            system_id: open_tongbao.system_id,
            tongbao_id: open_tongbao.tongbao_id,
            hold_id: open_tongbao.hold_transfer_tb_id,
            from_ent_id: open_tongbao.apply_enterprise_id,
            hold_ent_id: open_tongbao.receive_enterprise_id,
            amount: open_tongbao.creditor_rights_amount,
            timestamp: open_tongbao.receive_time,
            balance: open_tongbao.creditor_rights_amount,
            transfer_type: "开立"
          )
        end
      rescue ActiveRecord::SerializationFailure => e
        retry
      end

      open_tongbao
    end
  end

  def self.save_redeem_tongbao(log, decode_tx)
    begin
      open_tongbao = OpenTongbao.find_or_initialize_by(system_id: log["info"]["systemId"], tongbao_id: log["info"]["creditorRightsNumID"])
      case log["abi"]["name"]
      when "PrePayment"
        open_tongbao.aes_pre_data = log["info"]["data"]
        open_tongbao.extra_pre_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["data"], log["info"]["systemId"]).to_s) unless decode_tx.auth_mode?
        open_tongbao.pre_transfer_ids = log["info"]["transferIdList"]
        open_tongbao.pre_financing_ids = log["info"]["financingIdList"]
        open_tongbao.pre_time = decode_tx.timestamp
      when "Payment"
        open_tongbao.aes_redeem_data = log["info"]["data"]
        open_tongbao.extra_redeem_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["data"], log["info"]["systemId"]).to_s) unless decode_tx.auth_mode?
        open_tongbao.redeem_time = decode_tx.timestamp
      end

      open_tongbao.save!
    rescue ActiveRecord::RecordNotUnique => e
      retry
    end

    if log["abi"]["name"] == "PrePayment"
      open_tongbao.pre_transfer_ids.to_a.each do |transfer_id|
        CirculationTongbao.find_by!(system_id: open_tongbao.system_id, transfer_id: transfer_id).update!(pre_freeze_time: decode_tx.timestamp) if transfer_id.present?
      end
      open_tongbao.pre_financing_ids.to_a.each do |financing_id|
        FinancingTongbao.find_by!(system_id: open_tongbao.system_id, financing_id: financing_id).update!(pre_freeze_time: decode_tx.timestamp) if financing_id.present?
      end
    end

    open_tongbao
  end

  def pushing_datas
    return [] unless received
    data = [{
      tongbao_id: tongbao_id,
      data: {
        bizType: "开立",
        operatorType: "交易成功",
        sendName: create_ent.ent_name,
        sendCode: create_ent.institutions_id,
        receiveName: receive_ent.ent_name,
        receiveCode: receive_ent.institutions_id,
        transactionAmount: creditor_rights_amount.to_6,
        endTime: payment_date.to_s,
        bizDetailNo: hold_transfer_tb_id,
        fromBizDetailNo: nil,
        bizNo: tongbao_id,
        extData: extra_receive_data.to_json,
      }
    }]
  end

end
