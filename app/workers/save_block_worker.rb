# frozen_string_literal: true

class SaveBlockWorker
  include Sidekiq::Worker

  sidekiq_options queue: "event_loop"

  # @param hex_num_str [String] hex number
  def perform(hex_num_str)
    CitaSync::Persist.save_block(hex_num_str)
  end
end
