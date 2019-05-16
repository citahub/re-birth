# frozen_string_literal: true

class Api::V2::TransactionsController < ApplicationController
  # params:
  # {
  #   "account":  "the addr transactions related to", // hash
  #   "from":  "the addr transactions from", // hash
  #   "to":  "the addr transactions to", // hash
  #   "page": "1", // default 1
  #   "per_page": "10", // default 10
  #   "value_format": "decimal", // set value to decimal number, default hex number
  #
  #   # offset and limit has lower priority than page and perPage
  #   "offset":  "1", // default to 0
  #   "limit":  "10", // default to 10
  # }
  #
  # GET /api/v2/transactions
  def index
    params.transform_keys!(&:underscore)

    # use ILIKE to ignore case
    options = {
      from_or_to_matches: params[:account],
      from_matches: params[:from],
      to_matches: params[:to]
    }

    # FIXME: should order by block_number and index desc, change block_number to integer
    transactions = Transaction.ransack(options).result.order(updated_at: :desc)

    if params[:page].nil? && (!params[:offset].nil? || !params[:limit].nil?)
      offset = params[:offset] || 0
      limit = params[:limit] || 10
      transactions = transactions.offset(offset).limit(limit)
    else
      transactions = transactions.page(params[:page]).per(params[:per_page])
    end

    # TODO: provide V2 api to set default value decimal
    decimal_value = params[:value_format] == "decimal"

    render json: {
      result: {
        transactions: ActiveModelSerializers::SerializableResource.new(transactions, each_serializer: ::Api::TransactionSerializer, decimal_value: decimal_value)
      }
    }
  end
end
