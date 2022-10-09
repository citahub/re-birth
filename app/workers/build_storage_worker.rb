# frozen_string_literal: true

class BuildStorageWorker
  include Sidekiq::Worker

  sidekiq_options queue: "push_storage"

  def perform(tx_hash)
    return if StorageRecord.exists?(tx_hash: tx_hash)
    decode_tx = DecodeTransaction.find(tx_hash)
    system_id = decode_tx.pretty_params["_systemId"]
    datas = []

    case [decode_tx.api_name, decode_tx.contract_name]
    # 开立成功
    when ["receiveCreditorRights", "CreditorRights"]
      tongbao_id = decode_tx.request_args[1]
      open_tongbao = OpenTongbao.find_by!(system_id: system_id, tongbao_id: tongbao_id)
      datas = open_tongbao.pushing_datas
    # 流转申请
    when ["ctcreditorsTransfer", "CreditorsTransfer"]
      circulation_tongbao = CirculationTongbao.find_by!(system_id: system_id, transfer_id: decode_tx.request_args[1])
      datas = circulation_tongbao.pushing_datas("锁定", circulation_tongbao.extra_data)
    # 流转撤销 平台或申请方发起
    when ["ctcreditorsCancel", "CreditorsTransfer"], ["ctcreditorsCancelByPlatform", "CreditorsTransfer"]
      circulation_tongbao = CirculationTongbao.find_by!(system_id: system_id, transfer_id: decode_tx.request_args[1])
      datas = circulation_tongbao.pushing_datas("解锁", circulation_tongbao.extra_cancel_data)
    # 流转平台审核
    when ["ctplatformReview", "CreditorsTransfer"]
      circulation_tongbao = CirculationTongbao.find_by!(system_id: system_id, transfer_id: decode_tx.request_args[1])
      datas = circulation_tongbao.pushing_platform_unlock_datas
    # 流转供应商接收
    when ["ctcreditorsReceive", "CreditorsTransfer"]
      circulation_tongbao = CirculationTongbao.find_by!(system_id: system_id, transfer_id: decode_tx.request_args[1])
      datas = circulation_tongbao.pushing_receive_datas
    # 融资申请
    when ["applyCreditorsFinancing", "CreditorsFinancing"]
      financing_tongbao = FinancingTongbao.find_by!(system_id: system_id, financing_id: decode_tx.request_args[2])
      datas = financing_tongbao.pushing_datas("锁定", financing_tongbao.extra_data)
    # 融资平台审核
    when ["financingPlatformReview", "CreditorsFinancing"]
      financing_tongbao = FinancingTongbao.find_by!(system_id: system_id, financing_id: decode_tx.request_args[2])
      datas = financing_tongbao.pushing_platform_unlock_datas
    # 融资撤销
    when ["cancelFinancing", "CreditorsFinancing"]
      financing_tongbao = FinancingTongbao.find_by!(system_id: system_id, financing_id: decode_tx.request_args[1])
      datas = financing_tongbao.pushing_datas("解锁", financing_tongbao.extra_cancel_data)
    # 融资机构接受融资
    when ["acceptFinancing", "CreditorsFinancing"]
      financing_tongbao = FinancingTongbao.find_by!(system_id: system_id, financing_id: decode_tx.request_args[2])
      datas = financing_tongbao.pushing_receive_datas
    # 冻结/解冻
    when ["freeze", "Payment"]
      freeze_info = FreezeTongbao.find_by!(tx_hash: decode_tx.tx_hash)
      datas = freeze_info.build_push_datas
    # 预兑付/兑付
    when ["prePayment", "Payment"], ["payment", "Payment"]
      if decode_tx.api_name == "prePayment"
        unlocked_tongbaos = LockTongbao.where(system_id: system_id, tx_hash: decode_tx.tx_hash)
        datas = unlocked_tongbaos.map{ |unlocked_tongbao| unlocked_tongbao.pushing_data(nil) }
      end

      freeze_items = FreezeItem.where(tx_hash: decode_tx.tx_hash).where("amount > 0")
      datas += freeze_items.map{|freeze_item| freeze_item.pushing_data(nil)}
    # 质押申请
    when ["applyPledge", "CreditorsPledge"]
      pledge_tongbao = PledgeTongbao.find_by!(system_id: system_id, pledge_id: decode_tx.request_args[1])
      datas = pledge_tongbao.pushing_apply_datas
    # 质押撤销
    when ["cancelPledge", "CreditorsPledge"]
      pledge_tongbao = PledgeTongbao.find_by!(system_id: system_id, pledge_id: decode_tx.request_args[1])
      datas = pledge_tongbao.pushing_cancel_datas
    # 质押受理
    when ["acceptPledge", "CreditorsPledge"]
      pledge_tongbao = PledgeTongbao.find_by!(system_id: system_id, pledge_id: decode_tx.request_args[1])
      datas = pledge_tongbao.pushing_receive_datas
    end

    datas.each do |data|
      data[:data].merge!({bizTime: decode_tx.timestamp.to_s})
    end

    records = []
    ApplicationRecord.transaction do
      records = datas.map do |data|
        StorageRecord.create!({
          tx_hash: decode_tx.tx_hash,
          block_number: decode_tx.block_number,
          tx_index: decode_tx.tx_index,
          token_id: data[:tongbao_id],
          data: data[:data],
          system_id: system_id,
          store_index: SecureRandom.uuid.remove("-"),
        })
      end
    end

    PushStorageWorker.push_bulk(records.map(&:id))
  end


end
