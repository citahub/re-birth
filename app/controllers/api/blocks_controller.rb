class Api::BlocksController < ApplicationController
  # params:
  # {
  #   "numberFrom": "10" or "0xa", //  number or integer
  #   "numberTo": "20", // number or integer
  #   "transactionFrom": "min transaction count", // integer
  #   "transactionTo": "max transaction count", // integer
  #   "page": "1", // default 1
  #   "perPage": "10", // default 10
  #
  #   # offset and limit has lower priority than page and perPage
  #   "offset": "1", // database offset for pagination
  #   "limit": "10", //database limit for pagination
  # }
  # GET /api/blocks
  def index
    options = {
      block_number_gteq: parse_hex(params[:numberFrom]),
      block_number_lteq: parse_hex(params[:numberTo]),
      transaction_count_gteq: parse_hex(params[:transactionFrom]),
      transaction_count_lteq: parse_hex(params[:transactionTo])
    }

    blocks = Block.ransack(options).result.order(block_number: :desc)

    if params[:page].nil? && !params[:offset].nil?
      # use offset and limit
      total_count = blocks.count
      blocks = blocks.offset(params[:offset]).limit(params[:limit])
    else
      # use page and perPage
      blocks = blocks.page(params[:page]).per(params[:perPage])
      total_count = blocks.total_count
    end

    render json: {
      result: {
        count: total_count,
        blocks: ActiveModelSerializers::SerializableResource.new(blocks, each_serializer: ::Api::BlockSerializer)
      }
    }
  end

  private

  def parse_hex(number)
    return number.to_i(16) if number.to_s.downcase.start_with?("0x")
    number
  end
end
