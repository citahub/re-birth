class Api::StatusController < ApplicationController
  def index
    process = system("ruby #{Rails.root.join('lib', 'sync_control.rb')} status")

    render json: {
      result: {
        status: process ? "running" : "not running",
        currentBlockNumber: HexUtils.to_hex(Block.current_block_number || 0),
        currentChainBlockNumber: CitaSync::Api.block_number["result"]
      }
    }
  end
end
