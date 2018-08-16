class Api::SyncErrorsController < ApplicationController
  # params:
  # {
  #   "page": "1", // default 1
  #   "perPage": "10", // default 10
  #
  #   # offset and limit has lower priority than page and perPage
  #   "offset":  "1", // default to 0
  #   "limit":  "10", // default to 10
  # }
  #
  # GET /api/sync_errors
  def index
    sync_errors = SyncError.order(created_at: :desc)

    if params[:page].nil? && (!params[:offset].nil? || !params[:limit].nil?)
      offset = params[:offset] || 0
      limit = params[:limit] || 10
      total_count = sync_errors.count
      sync_errors = sync_errors.offset(offset).limit(limit)
    else
      sync_errors = sync_errors.page(params[:page]).per(params[:perPage])
      total_count = sync_errors.total_count
    end

    render json: {
      result: {
        count: total_count,
        syncErrors: ActiveModelSerializers::SerializableResource.new(sync_errors, each_serializer: Api::SyncErrorSerializer)
      }
    }
  end
end
