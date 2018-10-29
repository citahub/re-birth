# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActionController::RoutingError do |e|
    render json: {
      message: e.message
    }, status: :not_found
  end

  def not_found
    raise ActionController::RoutingError, "not found"
  end

  def homepage
    render json: {
      message: "Read more api interface info in https://github.com/cryptape/re-birth"
    }
  end
end
