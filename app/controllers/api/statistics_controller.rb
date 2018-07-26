class Api::StatisticsController < ApplicationController
  BLOCK_COUNT = 100

  # params:
  # {
  #   type: "proposals" or "brief"
  # }
  #
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

  # calculate proposal, for statistic of count of every proposer.
  # return a rendered json like this.
  #
  # [
  #   {
  #     "validator": proposer of block header,
  #     "count": count of this proposer
  #   }
  # ]
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

  # calculate brief, for statistic of tps, tpb, and ipb
  # return a rendered json
  #
  # {
  #   tps: float number, // transaction count per second
  #   tpb: float number, // transaction count per block
  #   ipb: float number, // average block interval
  # }
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
