class CitaController < ApplicationController
  include SplitRequestsConcern

  # rpc interface, same format with CITA rpc interface.
  #
  # POST /
  def index
    resp = find(params)
    render json: resp
  end

end
