ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

module MockHelper
  def stub_request_wrapper(method, params, result)
    include_hash = if params.nil?
                     { method: method }
                   else
                     { method: method, params: params }
                   end
    stub_request(:post, "www.cita.com").
      with(body: hash_including(include_hash), headers: { "Content-Type": "application/json" }).
      to_return(status: 200, body: { jsonrpc: "2.0", id: 83, result: result }.to_json)
  end
end

class ActiveSupport::TestCase
  include MockHelper
end
