# frozen_string_literal: true

class Api::StatusController < ApplicationController
  # GET /api/status
  def index

    chain_block_number = nil
    begin
      chain_block_number = CitaSync::Api.block_number["result"]&.hex
    rescue Exception => e
    end

    sync_info = SyncInfo.find_by(name: "current_block_number")
    block_number = sync_info&.value

    sidekiq_processe_size = 0
    begin
      sidekiq_processe_size = Sidekiq::ProcessSet.new.size
    rescue Exception => e
    end

    case
    when chain_block_number.nil?
      code = 40301
      message = "链无法访问"
    when sync_info.blank? || block_number.nil?
      code = 40302
      message = "未启动同步进程"
    when (chain_block_number == block_number) && (Time.current - sync_info.updated_at) > 50
      code = 40303
      message = "链高度保持不变，链异常"
    when (chain_block_number - block_number) < 0
      code = 40304
      message = "链被重置，请停数据服务，并清库清redis"
    when (Time.current - sync_info.updated_at) > 50
      code = 40305
      message = "同步服务异常"
    when sidekiq_processe_size == 0
      code = 40306
      message = "sidekiq没有正常运行"
    else
      code = 0
      message = "正常"
    end

    status = (code == 0 ? :ok : :internal_server_error)

    render status: status, json: {
      result: {
        code: code,
        message: message,
        currentBlockNumber: block_number.to_i,
        currentChainBlockNumber: chain_block_number
      }
    }
  end
end
