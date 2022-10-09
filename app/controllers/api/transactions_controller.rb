# frozen_string_literal: true

class Api::TransactionsController < ApplicationController
  # params:
  # {
  #   "account":  "the addr transactions related to", // hash
  #   "from":  "the addr transactions from", // hash
  #   "to":  "the addr transactions to", // hash
  #   "page": "1", // default 1
  #   "perPage": "10", // default 10
  #   "valueFormat": "decimal", // set value to decimal number, default hex number
  #
  #   # offset and limit has lower priority than page and perPage
  #   "offset":  "1", // default to 0
  #   "limit":  "10", // default to 10
  # }
  #
  # GET /api/transactions
  def index
    # use ILIKE to ignore case
    options = {
      from_or_to_matches: params[:account],
      from_matches: params[:from],
      to_matches: params[:to]
    }

    # FIXME: should be order by block_number and index desc, change block_number to integer
    transactions = Transaction.ransack(options).result.order(updated_at: :desc)

    if params[:page].nil? && (!params[:offset].nil? || !params[:limit].nil?)
      offset = params[:offset] || 0
      limit = params[:limit] || 10
      total_count = transactions.count
      transactions = transactions.offset(offset).limit(limit)
    else
      transactions = transactions.page(params[:page]).per(params[:perPage])
      total_count = transactions.total_count
    end

    # TODO: provide V2 api to set default value decimal
    decimal_value = params[:valueFormat] == "decimal"

    render json: {
      result: {
        count: total_count,
        transactions: ActiveModelSerializers::SerializableResource.new(transactions, each_serializer: ::Api::TransactionSerializer, decimal_value: decimal_value)
      }
    }
  end

  # GET /api/transactions/:hash
  def show
    # use ILIKE to ignore case
    options = {
      from_or_to_matches: params[:account],
      from_matches: params[:from],
      to_matches: params[:to]
    }

    transaction = Transaction.where(tx_hash: params[:hash]).ransack(options).result.first

    # return nil if transaction not found
    if transaction.nil?
      return render json: {
        result: {
          transaction: nil
        }
      }
    end

    decimal_value = params[:valueFormat] == "decimal"

    render json: {
      result: {
        transaction: ::Api::TransactionSerializer.new(transaction, decimal_value: decimal_value)
      }
    }
  end
end
