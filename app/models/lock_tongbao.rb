class LockTongbao < ApplicationRecord
  self.primary_key = %i(tx_hash log_index)

  def self.save_lock_tongbao(log, decode_tx, log_index)
    ApplicationRecord.transaction(isolation: :serializable) do
      lock_tongbao = LockTongbao.find_or_initialize_by(tx_hash: decode_tx.tx_hash, log_index: log_index)
      lock_tongbao.system_id = log["info"]["systemId"]
      lock_tongbao.tongbao_id = log["info"]["holdTransferTbId"]
      lock_tongbao.lock_value = log["info"]["lockValue"]
      lock_tongbao.to_ent_id = log["info"]["toInstitutionsId"]
      lock_tongbao.is_lock = log["info"]["lock"]
      lock_tongbao.origin_function = log["info"]["originFunction"]
      lock_tongbao.business_id = log["info"]["businessId"]
      lock_tongbao.business_name = log["info"]["businessName"]
      lock_tongbao.timestamp = decode_tx.timestamp
      lock_tongbao.save!

      total_lock = LockTongbao.where(system_id: lock_tongbao.system_id, tongbao_id: lock_tongbao.tongbao_id, is_lock: true).sum(:lock_value)
      total_unlock = LockTongbao.where(system_id: lock_tongbao.system_id, tongbao_id: lock_tongbao.tongbao_id, is_lock: false).sum(:lock_value)

      tongbao = Tongbao.find_by!(system_id: lock_tongbao.system_id, hold_id: log["info"]["holdTransferTbId"])
      tongbao.update!(lock_amount: (total_lock - total_unlock))

      if log["info"]["businessName"] == "pledge" && log["info"]["lock"] == false
        pledge = PledgeTongbao.find_or_initialize_by(system_id: log["info"]["systemId"], pledge_id: log["info"]["businessId"])
        pledge.unlock_hold_ids = (pledge.unlock_hold_ids.to_a << lock_tongbao.tongbao_id)
        pledge.save!
      end
    end
  rescue ActiveRecord::SerializationFailure => e
    retry
  end

  def pushing_data(extra_data)
    tongbao = Tongbao.find([system_id, tongbao_id])
    from_ent = tongbao.hold_ent
    case business_name
    when "pledge"
      pledge = PledgeTongbao.find([system_id, business_id])
      to_ent = Institution.find_by!(system_id: system_id, institutions_id: pledge.receive_enterprise_id)
      biz_type = "质押"
      biz_detail_no = tongbao_id
    when "transfer"
      circulation = CirculationTongbao.find([system_id, business_id])
      to_ent = Institution.find_by!(system_id: system_id, institutions_id: circulation.recevier_id)
      biz_type = (to_ent.financial_code.present? && from_ent.financial_code.present?) ? "再流转" : "流转"
      biz_detail_no = circulation.hold_transferee_tb_id_list[circulation.transfer_tb_id_list.find_index(tongbao_id)]
    when "financing"
      financing = FinancingTongbao.find([system_id, business_id])
      to_ent = Institution.find_by!(system_id: system_id, institutions_id: financing.creditors_financing_id)
      biz_type = "融资"
      biz_detail_no = financing.split_hold_transfer_tb_id_list[financing.hold_transfer_tb_id_list.find_index(tongbao_id)]
    else
      raise "非法的锁定类型"
    end

    {
      tongbao_id: tongbao.tongbao_id,
      data: {
        bizType: biz_type,
        operatorType: (is_lock ? "锁定" : "解锁"),
        sendName: from_ent.ent_name,
        sendCode: from_ent.institutions_id,
        receiveName: to_ent.ent_name,
        receiveCode: to_ent.institutions_id,
        transactionAmount: lock_value.to_6,
        endTime: nil,
        fromBizDetailNo: tongbao_id,
        bizDetailNo: biz_detail_no,
        bizNo: business_id,
        extData: extra_data.to_json,
      }
    }
  end

end
