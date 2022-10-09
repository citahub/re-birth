# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require_relative "config/environment"

# require 'prometheus/middleware/collector'

# use Prometheus::Middleware::Collector
use Prometheus::Middleware::CustomExporter

run Rails.application
