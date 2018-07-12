class Api::TransactionsController < ApplicationController
  # params:
  # {
  #   "account":  "the addr transactions related to", // hash
  #   "from":  "the addr transactions from", // hash
  #   "to":  "the addr transactions to", // hash
  #   "page": "1", // default 1
  #   "perPage": "10", // default 10
  #
  #   # offset and limit has lower priority than page and perPage
  #   "offset":  "1", // default to 0
  #   "limit":  "10", // default to 10
  # }
  # GET /api/transactions
  def index
    options = {
      from_or_to_eq: params[:account],
      from_eq: params[:from],
      to_eq: params[:to]
    }

    transactions = Transaction.includes(:block).ransack(options).result.order(block_number: :desc)

    if params[:page].nil? && !params[:offset].nil?
      total_count = transactions.count
      transactions = transactions.offset(params[:offset]).limit(params[:limit])
    else
      transactions = transactions.page(params[:page]).per(params[:perPage])
      total_count = transactions.total_count
    end

    render json: {
      result: {
        count: total_count,
        transactions: ActiveModelSerializers::SerializableResource.new(transactions, each_serializer: ::Api::TransactionSerializer)
      }
    }
  end
end
