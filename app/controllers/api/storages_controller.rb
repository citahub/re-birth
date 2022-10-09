class Api::StoragesController < ApplicationController

  def callback
    record = StorageRecord.find(params["record_id"])
    data = Oj.load(request.body.read)
    record.update!(tx_receipt: data, status: "tx_receipt")
    render plain: "SUCCESS"
  end
end