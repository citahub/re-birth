class CitaController < ApplicationController
  # rpc interface, same format with CITA rpc interface.
  #
  # POST /rpc_api/v1/cita
  def index
    resp = SplitRequestsController.find(params)
    render json: resp
  end

end
