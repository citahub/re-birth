class CirculationTongbao < ApplicationRecord
  self.primary_key = %i(system_id transfer_id)

  scope :applying, -> { where(is_adopt: [true, nil], cancel_time: nil, receive_time: nil, freeze_time: nil, pre_freeze_time: nil) }

  def self.save_circulation_tongbao(log, decode_tx)
    begin
      circulation_tongbao = CirculationTongbao.find_or_initialize_by(system_id: log["info"]["systemId"], transfer_id: log["info"]["transferId"])

      case log["abi"]["name"]
      when "CTCreditorsTransfer"
        circulation_tongbao.aes_data = log["info"]["data"]
        circulation_tongbao.extra_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["data"], log["info"]["systemId"]).to_s) unless decode_tx.auth_mode?
        circulation_tongbao.transfer_tb_id_list = log["info"]["transferTbIdList"]
        circulation_tongbao.hold_transferee_tb_id_list = log["info"]["holdTransfereeTbIdList"]
        circulation_tongbao.amount_list = log["info"]["amountList"]
        circulation_tongbao.recevier_id = log["info"]["receiveEnterprise"]
        circulation_tongbao.apply_time = decode_tx.timestamp
      when "CTPlatformReview"
        circulation_tongbao.aes_review_data = log["info"]["data"]
        circulation_tongbao.extra_review_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["data"], log["info"]["systemId"]).to_s) unless decode_tx.auth_mode?
        circulation_tongbao.is_adopt = log["info"]["accept"]
        circulation_tongbao.review_time = decode_tx.timestamp
      when "CTCreditorsCancel"
        circulation_tongbao.aes_cancel_data = log["info"]["data"]
        circulation_tongbao.extra_cancel_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["data"], log["info"]["systemId"]).to_s) unless decode_tx.auth_mode?
        circulation_tongbao.cancel_time = decode_tx.timestamp
      when "CTCreditorsReceive"
        circulation_tongbao.aes_receive_data = log["info"]["data"]
        circulation_tongbao.extra_receive_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["data"], log["info"]["systemId"]).to_s) unless decode_tx.auth_mode?
        circulation_tongbao.is_receive = log["info"]["accept"]
        circulation_tongbao.receive_time = decode_tx.timestamp
      end

      circulation_tongbao.save!
    rescue ActiveRecord::RecordNotUnique => e
      retry
    end

    if log["abi"]["name"] == "CTCreditorsReceive" && log["info"]["accept"] == true
      circulation_tongbao.reload.hold_transferee_tb_id_list.each_with_index do |hold_id, index|
        begin
          ApplicationRecord.transaction(isolation: :serializable) do
            Tongbao.create!(
              system_id: circulation_tongbao.system_id,
              hold_id: hold_id,
              from_hold_id: circulation_tongbao.transfer_tb_id_list[index],
              hold_ent_id: circulation_tongbao.recevier_id,
              amount: circulation_tongbao.amount_list[index],
              timestamp: circulation_tongbao.receive_time,
              balance: circulation_tongbao.amount_list[index],
              transfer_no: circulation_tongbao.transfer_id,
              transfer_type: "流转"
            )
          end
        rescue ActiveRecord::SerializationFailure => e
          retry
        end
      end
    end

    circulation_tongbao
  end

  def pushing_datas(lock_type, ext_info)
    datas = []
    to_ent = Institution.find_by!(system_id: system_id, institutions_id: recevier_id)
    transfer_tb_id_list.each_with_index do |from_hold_id, index|
      tongbao = Tongbao.find_by!(system_id: system_id, hold_id: from_hold_id)
      from_ent = tongbao.hold_ent
      biz_type = (to_ent.financial_code.present? && from_ent.financial_code.present?) ? "再流转" : "流转"

      data = {
        tongbao_id: tongbao.tongbao_id,
        data: {
          bizType: biz_type,
          operatorType: lock_type,
          sendName: from_ent.ent_name,
          sendCode: from_ent.institutions_id,
          receiveName: to_ent.ent_name,
          receiveCode: to_ent.institutions_id,
          transactionAmount: amount_list[index].to_6,
          endTime: nil,
          fromBizDetailNo: from_hold_id,
          bizDetailNo: hold_transferee_tb_id_list[index],
          bizNo: transfer_id,
          extData: ext_info.to_json,
        }
      }

      datas << data
    end

    datas
  end

  def pushing_platform_unlock_datas
    return [] if is_adopt
    pushing_datas("解锁", extra_review_data)
  end

  def pushing_receive_datas
    datas = pushing_datas("解锁", extra_receive_data)
    return datas unless is_receive
    datas += pushing_datas("交易成功", extra_receive_data)

    datas
  end
end
