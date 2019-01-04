# frozen_string_literal: true

class Api::InfosController < ApplicationController
  # GET /api/infos/url
  def url
    uri = URI.parse(ENV["CITA_URL"])
    ws_port = ENV["CITA_WS_PORT"]

    ws_uri = uri.dup
    ws_uri.port = ws_port

    render json: {
      result: {
        http_url: uri.to_s,
        ws_url: ws_uri.to_s
      }
    }
  end
end
