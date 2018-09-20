class Api::Erc20TransfersController < ApplicationController
  # GET /api/erc20/transfers
  def index
    address = params[:address]

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
    transfers = Erc20Transfer.where(address: address).order(id: :desc).ransack(options).result


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
        transfers: ActiveModelSerializers::SerializableResource.new(transfers, each_serializer: ::Api::Erc20TransferSerializer)
      }
    }
  end
end
