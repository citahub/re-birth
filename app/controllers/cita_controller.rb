class CitaController < ApplicationController
  # rpc interface, same format with CITA rpc interface.
  #
  # POST /
  def index
    resp = SplitRequestsController.find(params)
    render json: resp
  end

end
