class Api::StatisticsController < ApplicationController
  BLOCK_COUNT = 100

  # params:
  # {
  #   type: "proposals" or "brief"
  # }
  # GET /api/statistics
  def index
    case params[:type]
    when "proposals"
      proposals
    when "brief"
      brief
    else
      ""
    end
  end

  private

  def proposals
    blocks = Block.select("header->>'proposer' as proposer")
    proposers = blocks.distinct("proposers").map(&:proposer)

    result = proposers.map do |proposer|
      count = Block.where("header->>'proposer' = ?", proposer).count
      {
        "validator": proposer,
        count: count
      }
    end

    render json: {
      result: result
    }
  end

  def brief
    blocks = Block.order(block_number: :desc).limit(BLOCK_COUNT)
    end_timestamp = blocks.first.timestamp
    start_timestamp = blocks.last.timestamp
    seconds = (end_timestamp - start_timestamp) / 1000
    transaction_count = blocks.map(&:transaction_count).reduce(:+)
    tps = transaction_count.to_f / seconds
    tpb = transaction_count.to_f / BLOCK_COUNT
    ipb = seconds.to_f / BLOCK_COUNT

    render json: {
      result: {
        tps: tps,
        tpb: tpb,
        ipb: ipb
      }
    }
  end

end
