class CitaController < ApplicationController
  # POST /rpc_api/v1/cita
  def index
    resp = SplitRequestsController.find(params)
    render json: resp
  end

end
