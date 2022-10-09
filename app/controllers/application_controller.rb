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
      message: "北京智汇信元科技有限公司"
    }
  end

  private

  def validate_platform
    if params[:systemId].blank?
      return render json: { error_code: 40004, error_message: "systemId不能为空" }
    end
    @platform = Platform.find_by(system_id: params[:systemId])
    unless @platform
      return render json: { error_code: 40005, error_message: "不存在的systemId" }
    end
  end

  def validate_sign
    if params[:sign].blank?
      return render json: { error_code: 40001, error_message: "sign不能为空" }
    end

    unless rsa_verify
      return render json: { error_code: 40002, error_message: "非法签名" }
    end
  end

  # x-www-form-urlencoded请求，值都是字符串，所以验签都以字符串对待，签名时要注意。
  def rsa_verify
    signed_keys = params.except(:action, :controller, :citum, :sign, params[:controller].split("/").last, :path).keys.sort
    sort_params = {}
    signed_keys.each{ |param| sort_params[param] = params[param] }

    pub = OpenSSL::PKey::RSA.new(ENV["PUBLIC_KEY"])
    digester = OpenSSL::Digest::SHA1.new
    # x-www-form-urlencoded会把加号替换位空字符
    sign = Base64.decode64(params[:sign].gsub(" ", "+"))
    return pub.verify(digester, sign, sort_params.to_json)
  end

end
