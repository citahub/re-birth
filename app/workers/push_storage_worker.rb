class PushStorageWorker
  include Sidekiq::Worker

  sidekiq_options queue: "push_storage", retry: 3

  def perform(stroage_record_id)
    record = StorageRecord.find(stroage_record_id)
    return if record.status == "tx_receipt" && record.tx_receipt.to_h["code"].to_i == 1
    callback_url = ENV["STORAGE_CALLBACK_URL"] + record.id.to_s
    invoke_time = (Time.current.to_f*1000).to_i
    platform = Platform.find(record.system_id)
    send_params = {
      adminId: platform.push_admin_id,
      callbackUrl: callback_url,
      chainId: ENV["STORAGE_CHAIN_ID"],
      dataInfo: record.data.to_json,
      invokeTime: invoke_time,
      requestSn: "#{record.id.to_s}-#{SecureRandom.uuid}",
      systemId: record.system_id,
      tokenId: record.token_id,
      tokenType: 1, #"应收账款"
    }
    if ENV["STORAGE_AUTH_PUBKEYS"].present?
      send_params.merge!({dataId: record.store_index, authPubKeys: ENV["STORAGE_AUTH_PUBKEYS"].split(";")})
      send_params = send_params.sort.to_h
    end

    pri = OpenSSL::PKey::RSA.new(ENV["STORAGE_PRIVATE_KEY"])
    sign = pri.sign('sha1', send_params.to_json)
    signature = Base64.encode64(sign)
    signature = signature.delete("\n").delete("\r")
    send_params[:sign] = signature

    record.update!(request_times: (record.request_times + 1), invoke_time: invoke_time)
    uri = URI.parse(ENV["STORAGE_FRONT_URL"])
    resp = Net::HTTP.post(uri, send_params.to_json, "Content-Type" => "application/json")
    tx_respond = Oj.load(resp.body)
    record.update!(tx_respond: tx_respond, status: "sent_tx")
    unless ["1", "50010"].include?(tx_respond["code"].to_s) #"50010" 已经上链成功
      raise "StorageRecord: #{record.id} tx_respond: #{tx_respond.to_json}"
    end
  end
end
