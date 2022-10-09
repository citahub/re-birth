# frozen_string_literal: true

class SaveDecodedInfoWorker
  include Sidekiq::Worker

  def perform(tx_hash)

    decode_tx = DecodeTransaction.find(tx_hash)
    platform = Platform.find_by(system_id: decode_tx.pretty_params["_systemId"])
    return unless platform

    decode_tx.decode_logs.each_with_index do |log, log_index|
      case log["abi"]["name"]
      when "CreatePlatform", "SetupTBManager", "PlatformRightsInfo"
        Platform.save_platform_info log, decode_tx
      when "ManagePlatformOperator"
        BackstagePersonnel.save_backstage_personnel log, decode_tx
      when "InstitutionsInfo", "RightsInfo", "RightsFreezeInfo"
        Institution.save_institution log, decode_tx
      when "ManageInstitutionsOperator"
        Operator.save_institutions_operator(log, decode_tx)
      when "CreateCreditorRights", "QuickCreateCreditorRights", "PlatformReview",
        "EnterpriseReview", "ReceiveCreditorRights", "CancelCreditorRights",
        "CancelCRPlatformConfirm", "CancelCRByPlatform", "UpdateInvoice"
        OpenTongbao.save_open_tongbao(log, decode_tx)
      when "CTCreditorsTransfer", "CTPlatformReview", "CTCreditorsReceive", "CTCreditorsCancel"
        CirculationTongbao.save_circulation_tongbao(log, decode_tx)
      when "CreditorsFinancingInfo", "PlatformReviewInfo", "AcceptFinancingInfo", "CancelFinancing", "AcceptFinancingSupplement"
        FinancingTongbao.save_financing_tongbao(log, decode_tx)
      when "PrePayment", "Payment"
        OpenTongbao.save_redeem_tongbao(log, decode_tx)
      when "FreezeInfo"
        FreezeTongbao.save_freeze_tongbao(log, decode_tx, log_index)
      when "FreezeToken"
        FreezeItem.save_freeze_item(log, decode_tx, log_index)
      when "LockCreditorRights"
        LockTongbao.save_lock_tongbao(log, decode_tx, log_index)
      when "RightsLockInfo"
        LockCredit.save_lock_credit(log, decode_tx, log_index)
      when "RightsAmountInfo"
        Institution.save_rights_amount(log, decode_tx)
      when "ApplyPledge", "CancelPledge", "AcceptPledge"
        PledgeTongbao.save_pledge_info(log, decode_tx)
      when "DataAuth", "RolesDataAuth"
        save_auth_data(log, decode_tx, platform)
      end
    end

    begin_push_block = platform.begin_push_block
    return if begin_push_block.nil? || begin_push_block < 1
    return if begin_push_block > decode_tx.block_number
    BuildStorageWorker.perform_async(tx_hash)
  end

  def save_auth_data(log, decode_tx, platform)
    index = log["info"]["_viewers"].index{ |address| address == platform.auth_address}
    return unless index

    auth_key = log["info"]["_keys"].split(",")[index]
    cipher = Sm2.decrypt(auth_key[2..-1], platform.auth_private_key)
    sm4_key, sm4_iv = cipher[0..31], cipher[32..-1]

    business_id = log["info"]["_businessId"]
    system_id = log["info"]["_systemId"]
    business_name = log["info"]["_businessName"]

    auth_oj, encrypt_field, decrypt_field = nil, nil , nil
    case business_name
    when "data.roles.platform"
      auth_oj = BackstagePersonnel.find_by!(system_id: system_id, address: log["info"]["_account"])
      encrypt_field, decrypt_field = "aes_data", "extra_data"
    when "data.roles.institutions"
      auth_oj = Operator.find_by!(system_id: system_id, institutions_id: log["info"]["_institutionsId"], address: log["info"]["_account"])
      decrypt_data = Oj.load(Sm4.decrypt_cbc(Base64.decode64(auth_oj.aes_data).unpack("H*").first, sm4_key, sm4_iv))
      auth_oj.update!(extra_data: decrypt_data, operator_id: decrypt_data["operatorId"])
      return
    when "data", "data.initRights", "data.updateRights", "data.rightsFreeze.freeze", "data.rightsFreeze.unfreeze"
      return if business_id == ""
      auth_oj = Institution.find_by!(system_id: system_id, institutions_id: business_id)
      encrypt_field, decrypt_field = "aes_data", "extra_data" if business_name == "data"
      encrypt_field, decrypt_field = "credit_aes_data", "credit_extra_data" if ["data.initRights", "data.updateRights"].include?(business_name)
      encrypt_field, decrypt_field = "freeze_aes_data", "freeze_extra_data" if ["data.rightsFreeze.freeze", "data.rightsFreeze.unfreeze"].include?(business_name)
    when "invoice" #特殊处理invoice提前返回
      auth_oj = OpenTongbao.find_by!(system_id: system_id, tongbao_id: business_id)
      invoices = auth_oj.invoice_decrypted.to_a
      auth_oj.invoice_encrypted.each_with_index do |encrypt_text, index|
        next if invoices[index]
        invoices[index] = Oj.load(Sm4.decrypt_cbc(Base64.decode64(encrypt_text).unpack("H*").first, sm4_key, sm4_iv))
      end
      auth_oj.update!(invoice_decrypted: invoices)
      return
    when "data.createCreditorRights", "data.enterpriseReview", "data.platformReview", "data.receiveCreditorRights",
      "data.cancelCreditorRights", "data.cancelCreditorRightsByPlatform", "data.prePayment", "data.payment"
      auth_oj = OpenTongbao.find_by!(system_id: system_id, tongbao_id: business_id)
      encrypt_field, decrypt_field = "aes_data", "extra_data" if business_name == "data.createCreditorRights"
      encrypt_field, decrypt_field = "aes_enterprise_data", "extra_enterprise_data" if business_name == "data.enterpriseReview"
      encrypt_field, decrypt_field = "aes_platform_data", "extra_platform_data" if business_name == "data.platformReview"
      encrypt_field, decrypt_field = "aes_receive_data", "extra_receive_data" if business_name == "data.receiveCreditorRights"
      encrypt_field, decrypt_field = "aes_cancel_data", "extra_cancel_data" if business_name == "data.cancelCreditorRights"
      encrypt_field, decrypt_field = "aes_refuse_data", "extra_refuse_data" if business_name == "data.cancelCreditorRightsByPlatform"
      encrypt_field, decrypt_field = "aes_pre_data", "extra_pre_data" if business_name == "data.prePayment"
      encrypt_field, decrypt_field = "aes_redeem_data", "extra_redeem_data" if business_name == "data.payment"
    when "data.ctcreditorsTransfer", "data.ctplatformReview", "data.ctcreditorsReceive", "data.ctcreditorsCancel", "data.ctcreditorsCancelByPlatform"
      auth_oj = CirculationTongbao.find_by!(system_id: system_id, transfer_id: business_id)
      encrypt_field, decrypt_field = "aes_data", "extra_data" if business_name == "data.ctcreditorsTransfer"
      encrypt_field, decrypt_field = "aes_review_data", "extra_review_data" if business_name == "data.ctplatformReview"
      encrypt_field, decrypt_field = "aes_receive_data", "extra_receive_data" if business_name == "data.ctcreditorsReceive"
      # 单独授权，不知道是平台撤销还是申请方撤销
      if ["data.ctcreditorsCancel", "data.ctcreditorsCancelByPlatform"].include?(business_name)
        return if decode_tx.request_abi["name"] == "dataAuth"
        encrypt_field, decrypt_field = "aes_cancel_data", "extra_cancel_data"
      end
    when "data.applyCreditorsFinancing", "data.financingPlatformReview", "data.acceptFinancing", "data.cancelFinancing"
      auth_oj = FinancingTongbao.find_by!(system_id: system_id, financing_id: business_id)
      encrypt_field, decrypt_field = "aes_data", "extra_data" if business_name == "data.applyCreditorsFinancing"
      encrypt_field, decrypt_field = "aes_platform_data", "extra_platform_data" if business_name == "data.financingPlatformReview"
      encrypt_field, decrypt_field = "aes_accept_data", "extra_accept_data" if business_name == "data.acceptFinancing"
      encrypt_field, decrypt_field = "aes_cancel_data", "extra_cancel_data" if business_name == "data.cancelFinancing"
    when "data.acceptFinancingSupplement"
      return if decode_tx.request_abi["name"] == "dataAuth"
      auth_oj = FinancingTongbao.find_by!(system_id: system_id, financing_id: business_id)
      decrypt_data = Oj.load(Sm4.decrypt_cbc(Base64.decode64(auth_oj.aes_supplement_data).unpack("H*").first, sm4_key, sm4_iv))
      auth_oj.extra_supplement_data << decrypt_data
      auth_oj.save!
      return
    when "data.applyPledge", "data.cancelPledge", "data.acceptPledge"
      auth_oj = PledgeTongbao.find_by!(system_id: system_id, pledge_id: business_id)
      encrypt_field, decrypt_field = "aes_data", "extra_data" if business_name == "data.applyPledge"
      encrypt_field, decrypt_field = "aes_cancel_data", "extra_cancel_data" if business_name == "data.cancelPledge"
      encrypt_field, decrypt_field = "aes_accept_data", "extra_accept_data" if business_name == "data.acceptPledge"
    when "data.freeze", "data.unfreeze"
      FreezeTongbao.where(system_id: system_id, tongbao_id: business_id).where("extra_data IS NULL").each do |freeze|
        decrypt_data = Oj.load(Sm4.decrypt_cbc(Base64.decode64(freeze.aes_data).unpack("H*").first, sm4_key, sm4_iv))
        freeze.update!(extra_data: decrypt_data)
      end
      return
    else
      return
    end

    decrypt_data = Oj.load(Sm4.decrypt_cbc(Base64.decode64(auth_oj.send(encrypt_field)).unpack("H*").first, sm4_key, sm4_iv))
    auth_oj.update!(decrypt_field => decrypt_data)
  end

end
