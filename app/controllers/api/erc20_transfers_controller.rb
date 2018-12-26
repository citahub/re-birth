# frozen_string_literal: true

class Api::Erc20TransfersController < ApplicationController
  # params:
  # {
  #   "account": "from or to", // hash
  #   "from": "from address", // hash
  #   "to": "to address", // hash
  #   "page": 1, // default 1
  #   "perPage": 10, // default 10
  #
  #   # offset and limit has lower priority than page and perPage
  #   "offset": 1, // default 0
  #   "limit": 10 // default 10
  # }

  # GET /api/erc20/transfers
  def index
    address = params[:address]&.downcase

    if address.nil?
      return render json: {
        message: "must have address"
      }
    end

    options = {
      from_or_to_matches: params[:account],
      from_matches: params[:from],
      to_matches: params[:to]
    }

    unless Erc20Transfer.exists?(address: address)
      Erc20Transfer.init_address(address)
    end
    transfers = Erc20Transfer.includes(:tx).where(address: address).order(created_at: :desc).ransack(options).result

    if params[:page].nil? && (!params[:offset].nil? || !params[:limit].nil?)
      offset = params[:offset] || 0
      limit = params[:limit] || 10
      total_count = transfers.count
      transfers = transfers.offset(offset).limit(limit)
    else
      transfers = transfers.page(params[:page]).per(params[:perPage])
      total_count = transfers.total_count
    end

    render json: {
      result: {
        count: total_count,
        transfers: ActiveModelSerializers::SerializableResource.new(transfers, each_serializer: ::Api::Erc20TransferSerializer, address: params[:address])
      }
    }
  end
end
