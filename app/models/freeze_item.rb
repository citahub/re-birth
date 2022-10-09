class FreezeItem < ApplicationRecord
  self.primary_key = %i(tx_hash log_index)

  def self.save_freeze_item(log, decode_tx, log_index)
    freeze_item = FreezeItem.find_or_initialize_by(tx_hash: decode_tx.tx_hash, log_index: log_index)
    freeze_item.system_id = log["info"]["systemId"]
    freeze_item.open_tongbao_id = log["info"]["creditorRightsNumID"]
    freeze_item.hold_id = log["info"]["holdTransferTbId"]
    freeze_item.amount = log["info"]["amount"]
    freeze_item.is_freeze = log["info"]["freeze"]
    freeze_item.origin_function = log["info"]["originFunction"]
    freeze_item.block_number = decode_tx.block_number
    freeze_item.save!

    tongbao = Tongbao.find_by!(system_id: freeze_item.system_id, hold_id: log["info"]["holdTransferTbId"])
    case freeze_item.origin_function
    when "prePayment"
      tongbao.update!(pre_redeem_time: decode_tx.timestamp)
    when "payment"
      tongbao.update!(redeem_time: decode_tx.timestamp, redeem_amount: freeze_item.amount)
    when "freeze"
      if freeze_item.is_freeze && decode_tx.block_number > tongbao.freeze_block_number.to_i
        tongbao.update!(freeze_block_number: decode_tx.block_number)
      end
      if !freeze_item.is_freeze && decode_tx.block_number > tongbao.unfreeze_block_number.to_i
        tongbao.update!(unfreeze_block_number: decode_tx.block_number)
      end
    end
  end

  def pushing_data(extra_data)
    case [origin_function, is_freeze]
    when ["freeze", true]
      biz_type, operator_type = "异常处理", "冻结"
    when ["freeze", false]
      biz_type, operator_type = "异常处理", "解冻"
    when ["prePayment", true]
      biz_type, operator_type = "兑付", "预兑付"
    when ["payment", false]
      biz_type, operator_type = "兑付", "兑付成功"
    end

    tongbao = Tongbao.find_by!(system_id: system_id, hold_id: hold_id)
    {
      tongbao_id: open_tongbao_id,
      data: {
        bizType: biz_type,
        operatorType: operator_type,
        sendName: tongbao.from_ent.ent_name,
        sendCode: tongbao.from_ent.institutions_id,
        receiveName: tongbao.hold_ent.ent_name,
        receiveCode: tongbao.hold_ent.institutions_id,
        transactionAmount: amount.to_6,
        bizDetailNo: hold_id,
        bizNo: (tongbao.transfer_no || open_tongbao_id),
        endTime: nil,
        fromBizDetailNo: tongbao.from_hold_id,
        extData: extra_data.to_json,
      }
    }
  end
end
