require 'prometheus/middleware/exporter'
# require 'prometheus/client'
module Prometheus
  module Middleware
    class CustomExporter < Prometheus::Middleware::Exporter
      def respond_with(format)
        prometheus = Prometheus::Client.registry
        prometheus.unregister(:trade_service_health)
        gauge = Prometheus::Client::Gauge.new(:trade_service_health, docstring: 'Health check for data service health',labels: [:code, :message])
        prometheus.register(gauge)

        chain_block_number = nil
        begin
          chain_block_number = CitaSync::Api.block_number["result"]&.hex
        rescue Exception => e
        end
        sync_info = nil
        ActiveRecord::Base.connection_pool.with_connection do
          sync_info = SyncInfo.find_by(name: "current_block_number")
        end
        block_number = sync_info&.value

        sidekiq_processe_size = 0
        begin
          sidekiq_processe_size = Sidekiq::ProcessSet.new.size
        rescue Exception => e
        end

        case
        when chain_block_number.nil?
          code = 40301
          message = "Unable to access chain"
        when sync_info.blank? || block_number.nil?
          code = 40302
          message = "Synchronization process is not running"
        when (chain_block_number <= block_number) && (Time.current - sync_info.updated_at) > 50
          code = 40303
          message = "Block height unchanged"
        when (block_number - chain_block_number) > 3
          code = 40304
          message = "Chain reset, please reset data service"
        when (Time.current - sync_info.updated_at) > 50
          code = 40305
          message = "Synchronization service exception"
        when sidekiq_processe_size == 0
          code = 40306
          message = "sidekiq is not running"
        else
          code = 0
          message = "Run well"
        end

        status = (code == 0 ? 1 : 0)

        gauge.set(status, labels: {code: code, message: message})

        super
      end
    end
  end
end