class FreezeTongbao < ApplicationRecord
  self.primary_key = %i(tx_hash log_index)

  def self.save_freeze_tongbao(log, decode_tx, log_index)
    freeze_tongbao = FreezeTongbao.find_or_initialize_by(tx_hash: decode_tx.tx_hash, log_index: log_index)
    freeze_tongbao.system_id = log["info"]["systemId"]
    freeze_tongbao.tongbao_id = log["info"]["creditorRightsNumID"]
    freeze_tongbao.aes_data = log["info"]["data"]
    freeze_tongbao.extra_data = Oj.load(DecodeUtils.try_sm4_dicrypt(log["info"]["data"], log["info"]["systemId"]).to_s) unless decode_tx.auth_mode?
    freeze_tongbao.transfer_ids = log["info"]["transferIdList"]
    freeze_tongbao.financing_ids = log["info"]["financingIdList"]
    freeze_tongbao.is_freeze = log["info"]["freeze"]
    freeze_tongbao.timestamp = decode_tx.timestamp
    freeze_tongbao.block_number = decode_tx.block_number
    freeze_tongbao.save!

    if freeze_tongbao.is_freeze
      freeze_tongbao.transfer_ids.to_a.each do |transfer_id|
        CirculationTongbao.find_by!(system_id: freeze_tongbao.system_id, transfer_id: transfer_id).update!(freeze_time: freeze_tongbao.timestamp) if transfer_id.present?
      end
      freeze_tongbao.financing_ids.to_a.each do |financing_id|
        FinancingTongbao.find_by!(system_id: freeze_tongbao.system_id, financing_id: financing_id).update!(freeze_time: freeze_tongbao.timestamp) if financing_id.present?
      end
    end
  end

  def build_push_datas
    datas = []
    if is_freeze
      circulation_tongbaos = CirculationTongbao.where(transfer_id: transfer_ids, system_id: system_id)
      circulation_tongbaos.each{|ct| datas += ct.pushing_datas("解锁", extra_data)}
      financing_tongbaos = FinancingTongbao.where(financing_id: financing_ids, system_id: system_id)
      financing_tongbaos.each{|ft| datas += ft.pushing_datas("解锁", extra_data)}
    end

    freeze_items = FreezeItem.where(tx_hash: tx_hash).where("amount > 0")
    datas += freeze_items.map{|freeze_item| freeze_item.pushing_data(extra_data)}
  end
end
