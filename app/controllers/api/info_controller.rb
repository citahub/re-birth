# frozen_string_literal: true

class Api::InfoController < ApplicationController
  # GET /api/info/url
  def url
    uri = URI.parse(ENV["CITA_URL"])
    ws_port = ENV["CITA_WS_PORT"]

    ws_uri = uri.dup
    ws_uri.port = ws_port

    cita_ws_protocol = ENV["CITA_WS_PROTOCOL"]
    if %w(ws wss).include?(cita_ws_protocol)
      ws_uri.scheme = cita_ws_protocol
    elsif uri.scheme == "http"
      ws_uri.scheme = "ws"
    else
      ws_uri.scheme = "wss"
    end

    render json: {
      result: {
        http_url: uri.to_s,
        ws_url: ws_uri.to_s
      }
    }
  end
end
