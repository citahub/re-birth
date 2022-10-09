# frozen_string_literal: true

class Api::EventLogsController < ApplicationController
  # params:
  # {
  #   "page": "1", // default 1
  #   "perPage": "10", // default 10
  # }
  #
  # GET /api/event_logs/:address
  def show
    address = params[:address]
    event_logs = EventLog.where("address ILIKE ?", address).order(block_number: :desc, log_index: :desc).page(params[:page]).per(params[:perPage])

    render json: {
      result: {
        count: event_logs.total_count,
        eventLogs: ActiveModelSerializers::SerializableResource.new(event_logs, each_serializer: ::Api::EventLogSerializer)
      }
    }
  end
end
