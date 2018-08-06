class Api::StatusController < ApplicationController
  def index
    process = system("ruby #{Rails.root.join('lib', 'sync_control.rb')} status")

    render json: {
      result: {
        status: process ? "running" : "not running",
        currentBlockNumber: CitaSync::Basic.number_to_hex_str(Block.current_block_number || 0),
        currentChainBlockNumber: CitaSync::Api.block_number["result"]
      }
    }
  end
end
