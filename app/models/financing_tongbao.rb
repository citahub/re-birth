class FinancingTongbao < ApplicationRecord
  self.primary_key = %i(system_id financing_id)

  scope :applying, -> { where(platform_agreed: [true, nil], cancel_time: nil, accept_time: nil, freeze_time: nil, pre_freeze_time: nil) }

  def self.save_financing_tongbao(log, decode_tx)
    begin
      financing_tongbao = FinancingTongbao.find_or_initialize_by(system_id: log["info"]["systemId"], financing_id: log["info"]["financingId"])
      case log["abi"]["name"]
      when "CreditorsFinancingInfo"
        financing_tongbao.aes_data = log["info"]["data"]
        financing_tongbao.extra_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["data"], log["info"]["systemId"]).to_s) unless decode_tx.auth_mode?
        financing_tongbao.financing_amount = log["info"]["financingAmount"]
        financing_tongbao.creditors_financing_id = log["info"]["receiveFinancingEnterprise"]
        financing_tongbao.hold_transfer_tb_id_list = log["info"]["holdTransferTbIdList"]
        financing_tongbao.split_hold_transfer_tb_id_list = log["info"]["splitHoldTransferTbIdList"]
        financing_tongbao.amount_list = log["info"]["amountList"]
        financing_tongbao.apply_financing_id = log["info"]["applyEnterprise"]
        financing_tongbao.apply_time = decode_tx.timestamp
      when "PlatformReviewInfo"
        financing_tongbao.aes_platform_data = log["info"]["data"]
        financing_tongbao.extra_platform_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["data"], log["info"]["systemId"]).to_s) unless decode_tx.auth_mode?
        financing_tongbao.platform_agreed = log["info"]["agreed"]
        financing_tongbao.platform_time = decode_tx.timestamp
      when "AcceptFinancingInfo"
        financing_tongbao.aes_accept_data = log["info"]["data"]
        financing_tongbao.extra_accept_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["data"], log["info"]["systemId"]).to_s) unless decode_tx.auth_mode?
        financing_tongbao.accept_agreed = log["info"]["agreed"]
        financing_tongbao.accept_time = decode_tx.timestamp
      when "CancelFinancing"
        financing_tongbao.aes_cancel_data = log["info"]["data"]
        financing_tongbao.extra_cancel_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["data"], log["info"]["systemId"]).to_s) unless decode_tx.auth_mode?
        financing_tongbao.cancel_time = decode_tx.timestamp
      when "AcceptFinancingSupplement"
        financing_tongbao.aes_supplement_data = log["info"]["data"]
        financing_tongbao.extra_supplement_data ||= []
        financing_tongbao.extra_supplement_data << Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["data"], log["info"]["systemId"]).to_s) unless decode_tx.auth_mode?
        financing_tongbao.supplement_time = decode_tx.timestamp
      end

      financing_tongbao.save!
    rescue ActiveRecord::RecordNotUnique => e
      retry
    end

    if log["abi"]["name"] == "AcceptFinancingInfo" && log["info"]["agreed"] == true
      financing_tongbao.reload.split_hold_transfer_tb_id_list.each_with_index do |hold_id, index|
        begin
          ApplicationRecord.transaction(isolation: :serializable) do
            Tongbao.create!(
              system_id: financing_tongbao.system_id,
              hold_id: hold_id,
              from_hold_id: financing_tongbao.hold_transfer_tb_id_list[index],
              hold_ent_id: financing_tongbao.creditors_financing_id,
              balance: financing_tongbao.amount_list[index],
              amount: financing_tongbao.amount_list[index],
              transfer_no: financing_tongbao.financing_id,
              timestamp: financing_tongbao.accept_time,
              transfer_type: "融资"
            )
          end
        rescue ActiveRecord::SerializationFailure => e
          retry
        rescue ActiveRecord::RecordNotUnique
        end
      end
    end

    financing_tongbao
  end

  def pushing_datas(lock_type, ext_info)
    datas = []
    from_ent = Institution.find_by!(system_id: system_id, institutions_id: apply_financing_id)
    to_ent = Institution.find_by!(system_id: system_id, institutions_id: creditors_financing_id)
    hold_transfer_tb_id_list.each_with_index do |from_hold_id, index|
      tongbao = Tongbao.find_by!(system_id: system_id, hold_id: from_hold_id)

      data = {
        tongbao_id: tongbao.tongbao_id,
        data: {
          bizType: "融资",
          operatorType: lock_type,
          sendName: from_ent.ent_name,
          sendCode: from_ent.institutions_id,
          receiveName: to_ent.ent_name,
          receiveCode: to_ent.institutions_id,
          transactionAmount: amount_list[index].to_6,
          endTime: nil,
          fromBizDetailNo: from_hold_id,
          bizDetailNo: split_hold_transfer_tb_id_list[index],
          bizNo: financing_id,
          extData: ext_info.to_json,
        }
      }

      datas << data
    end

    datas
  end

  def pushing_platform_unlock_datas
    return [] if platform_agreed
    pushing_datas("解锁", extra_platform_data)
  end

  def pushing_receive_datas
    datas = pushing_datas("解锁", extra_accept_data)
    return datas unless accept_agreed
    datas += pushing_datas("交易成功", extra_accept_data)
    datas
  end

end
