# frozen_string_literal: true

require "redis"
require "redis/objects"

redis_config = Rails.application.config_for(:redis)

$redis = Redis.new(url: redis_config["url"], driver: :hiredis, password: redis_config["password"])
Redis::Objects.redis = $redis
