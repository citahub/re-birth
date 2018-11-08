redis_config = Rails.application.config_for(:redis)
sidekiq_url = redis_config["url"]
redis_password = redis_config["password"]

namespace = ENV.fetch("REDIS_NAMESPACE") { "rebirth" }

Sidekiq.configure_server do |config|
  config.redis = { url: sidekiq_url, driver: :hiredis, password: redis_password, namespace: namespace }
end
Sidekiq.configure_client do |config|
  config.redis = { url: sidekiq_url, driver: :hiredis, password: redis_password, namespace: namespace }
end
