# frozen_string_literal: true

class CitaController < ApplicationController
  # rpc interface, same format with CITA rpc interface.
  #
  # POST /
  def index
    uri = URI.parse(ENV["CITA_URL"])
    citum = params[:citum]
    send_params = citum[:_json] || citum

    resp = Net::HTTP.post(uri, send_params.to_json, "Content-Type" => "application/json")
    data = Oj.load(resp.body)

    render json: data
  end
end
