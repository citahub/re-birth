class PledgeTongbao < ApplicationRecord
  self.primary_key = %i(system_id pledge_id)

  def self.save_pledge_info(log, decode_tx)
    begin
      pledge_tongbao = PledgeTongbao.find_or_initialize_by(system_id: log["info"]["_systemId"], pledge_id: log["info"]["_pledgeId"])

      case log["abi"]["name"]
      when "ApplyPledge"
        pledge_tongbao.apply_enterprise_id = log["info"]["applyEnterpriseId"]
        pledge_tongbao.aes_data = log["info"]["_data"]
        pledge_tongbao.extra_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["_data"], log["info"]["_systemId"]).to_s) unless decode_tx.auth_mode?
        pledge_tongbao.pledge_tb_id_list = log["info"]["_pledgeTbIdList"]
        pledge_tongbao.amount_list = log["info"]["_amountList"]
        pledge_tongbao.receive_enterprise_id = log["info"]["_receiveFinancingEnterprise"]
        pledge_tongbao.apply_time = decode_tx.timestamp
      when "CancelPledge"
        pledge_tongbao.aes_cancel_data = log["info"]["_data"]
        pledge_tongbao.extra_cancel_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["_data"], log["info"]["_systemId"]).to_s) unless decode_tx.auth_mode?
        pledge_tongbao.cancel_time = decode_tx.timestamp
      when "AcceptPledge"
        pledge_tongbao.aes_accept_data = log["info"]["_data"]
        pledge_tongbao.extra_accept_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["_data"], log["info"]["_systemId"]).to_s) unless decode_tx.auth_mode?
        pledge_tongbao.is_adopt = log["info"]["_accept"]
        pledge_tongbao.accept_time = decode_tx.timestamp
      end

      pledge_tongbao.save!
    rescue ActiveRecord::RecordNotUnique => e
      retry
    end
  end

  def pushing_datas(lock_type, ext_info)
    datas = []
    from_ent = Institution.find_by!(system_id: system_id, institutions_id: apply_enterprise_id)
    to_ent = Institution.find_by!(system_id: system_id, institutions_id: receive_enterprise_id)

    pledge_tb_id_list.each_with_index do |from_hold_id, index|
      tongbao = Tongbao.find_by!(system_id: system_id, hold_id: from_hold_id)

      data = {
        tongbao_id: tongbao.tongbao_id,
        data: {
          bizType: "质押",
          operatorType: lock_type,
          sendName: from_ent.ent_name,
          sendCode: from_ent.institutions_id,
          receiveName: to_ent.ent_name,
          receiveCode: to_ent.institutions_id,
          transactionAmount: amount_list[index].to_6,
          endTime: nil,
          fromBizDetailNo: from_hold_id,
          bizDetailNo: from_hold_id,
          bizNo: pledge_id,
          extData: ext_info.to_json,
        }
      }

      datas << data
    end

    datas
  end

  def pushing_receive_datas
    if is_adopt
      datas = pushing_datas("交易成功", extra_accept_data)
    else
      datas = pushing_datas("解锁", extra_accept_data)
    end
    datas
  end

  def pushing_apply_datas
    pushing_datas("锁定", extra_data)
  end

  def pushing_cancel_datas
    pushing_datas("解锁", extra_cancel_data)
  end

end
