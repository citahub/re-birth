class Api::BlocksController < ApplicationController
  # params:
  # {
  #   "numberFrom": "min block number", //  number or integer
  #   "numberTo": "max block number", // number or integer
  #   "transactionFrom": "min transaction count", // integer
  #   "transactionTo": "max transaction count", // integer
  #   "page": "1", // default 1
  #   "perPage": "10", // default 10
  # }
  # GET /api/blocks
  def index
    render json: {
      message: "Hello CITA"
    }
  end
end
