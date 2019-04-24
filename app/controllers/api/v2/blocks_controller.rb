# frozen_string_literal: true

class Api::V2::BlocksController < ApplicationController
  # get blocks info list and paginate it.
  #
  # params
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
  #
  # GET /v2/api/blocks
  def index
    params.transform_keys!(&:underscore)

    options = {
      block_number_gteq: parse_hex(params[:number_from]),
      block_number_lteq: parse_hex(params[:number_to]),
      transaction_count_gteq: parse_hex(params[:transaction_from]),
      transaction_count_lteq: parse_hex(params[:transaction_to])
    }

    blocks = Block.ransack(options).result.order(block_number: :desc)

    if params[:page].nil? && (!params[:offset].nil? || !params[:limit].nil?)
      offset = params[:offset] || 0
      limit = params[:limit] || 10
      # use offset and limit
      blocks = blocks.offset(offset).limit(limit)
    else
      # use page and perPage
      blocks = blocks.page(params[:page]).per(params[:per_page])
    end

    render json: {
      result: {
        blocks: ActiveModelSerializers::SerializableResource.new(blocks, each_serializer: ::Api::BlockSerializer)
      }
    }
  end

  private

  # convert hex string which has "0x" prefix to decimal number
  #
  # @param number [String] hex number string
  #
  # @return [Integer]
  def parse_hex(number)
    return number.to_i(16) if number.to_s.downcase.start_with?("0x")

    number
  end
end
