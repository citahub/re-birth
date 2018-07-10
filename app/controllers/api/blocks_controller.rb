class Api::BlocksController < ApplicationController
  # params:
  # {
  #   "numberFrom": "10" or "0xa", //  number or integer
  #   "numberTo": "20", // number or integer
  #   "transactionFrom": "min transaction count", // integer
  #   "transactionTo": "max transaction count", // integer
  #   "page": "1", // default 1
  #   "perPage": "10", // default 10
  # }
  # GET /api/blocks
  def index
    options = {
      block_number_gteq: parse_hex(params[:numberFrom]),
      block_number_lteq: parse_hex(params[:numberTo]),
      transaction_count_gteq: parse_hex(params[:transactionFrom]),
      transaction_count_lteq: parse_hex(params[:transactionTo])
    }

    blocks = Block.ransack(options).result.order(block_number: :desc).page(params[:page]).per(params[:perPage])

    render json: {
      count: blocks.total_count,
      blocks: ActiveModelSerializers::SerializableResource.new(blocks, each_serializer: ::Api::BlockSerializer)
    }
  end

  private

  def parse_hex(number)
    return number.to_i(16) if number.to_s.downcase.start_with?("0x")
    number
  end
end
