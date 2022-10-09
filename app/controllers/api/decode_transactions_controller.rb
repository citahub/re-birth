# frozen_string_literal: true

class Api::DecodeTransactionsController < ApplicationController
  def show
    decode_tx = DecodeTransaction.find_by(tx_hash: params[:tx_hash])
    unless decode_tx
      return render json: { error_code: 40200, error_message: "不存在的交易或正在排队解析" }
    end

    render json: {
      contract_address: decode_tx.contract_address,
      contract_name: decode_tx.contract_name,
      api_name: decode_tx.api_name,
      request_args: decode_tx.request_args,
      logs: decode_tx.decode_logs.map{|log|log["info"]},
    }
  end
end
