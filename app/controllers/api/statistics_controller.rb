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
    validators = MetaData.last&.validators
    result = Block.group("header ->> 'proposer'").count
               .map { |k, v| { validator: k, count: v } }
               .select { |b| validators.include?(b[:validator]) }

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

    block_count = [blocks.count, BLOCK_COUNT].min

    end_timestamp = blocks.first.timestamp
    start_timestamp = blocks.last.timestamp
    seconds = (end_timestamp - start_timestamp) / 1000
    transaction_count = blocks.map(&:transaction_count).reduce(:+)
    tps = transaction_count.to_f / seconds
    tpb = transaction_count.to_f / block_count
    ipb = seconds.to_f / block_count

    render json: {
      result: {
        tps: tps,
        tpb: tpb,
        ipb: ipb
      }
    }
  end

end
