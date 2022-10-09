# frozen_string_literal: true

class Api::QueryCitaController < ApplicationController
  before_action :validate_platform

  METHOD_NAMES = {
    "getPersonalInfo" => "BackstagePersonnel", #欧冶后台人员信息查询接口
    "getInstitutionsInfo" => "Institutions", #机构信息查询接口
    "getInstitutionsOperatorInfo" => "InstitutionsOperator", #机构操作员信息查询接口
    "getRightsInfo" => "RightsFactory", #授信信息查询接口
    "getAvailableBalance" => "RightsFactory", #获取企业授信可用金额
    "getCreditorAddress" => "RightsFactory", #开立资格查询接口
    "getCreditorRightsInfo" => "CreditorRightsFactory", #开立信息查询接口
    "getCreditorsTransfersApplyInfo" => "CreditorsTransfersFactory", #债权流转查询接口
    "getCreditorsFinancingInfo" => "CreditorsFinancingFactory", #债权融资信息查询
  }

  def index
    if params[:contract_address].blank?
      return render json: { error_code: 40101, error_message: "contract_address不能为空" }
    end

    if params[:method_name].blank?
      return render json: { error_code: 40102, error_message: "method_name不能为空" }
    end

    unless METHOD_NAMES.keys.include?(params[:method_name])
      return render json: { error_code: 40103, error_message: "不存在的method_name" }
    end

    params[:request_params] = params[:request_params].blank? ? [] : params[:request_params]

    unless params[:request_params].instance_of?(Array)
      return render json: { error_code: 40104, error_message: "request_params必须是数组" }
    end

    abi = ContractAbi.order(:timestamp).where(contract_name: METHOD_NAMES[params[:method_name]], is_static: true).last.abi
    unless abi
      return render json: { error_code: 40105, error_message: "不能识别的合约地址" }
    end

    cita_url = params[:is_pub].to_i == 1 ? ENV["PUB_CITA_URL"] : ENV["CITA_URL"]
    cita = CITA::Client.new(cita_url)
    contract = cita.contract_at(abi, params[:contract_address])

    begin
      cita_resp = contract.call_func(method: params[:method_name].to_sym, params: params[:request_params])
    rescue Exception => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.to_a
      return render json: { error_code: 40106, error_message: "链上返回错误" }
    end

    if cita_resp.nil?
      return render json: { error_code: 40107, error_message: "不存在的合约地址" }
    end

    resp = { result: cita_resp }

    section = abi.find{ |inputs| inputs["name"] == params[:method_name] }
    indexs = []
    section["outputs"].each_with_index do |input, index|
      indexs << index if input["type"] == "string"
    end
    return render({json: resp}) if indexs.blank?

    indexs.each do |index|
      dicrypted_string = cita_resp[index]
      next unless dicrypted_string.instance_of?(String)
      json_str = DecodeUtils.try_sm4_dicrypt(dicrypted_string, params[:systemId])
      resp[index] = json_str if json_str
    end

    render json: resp
  end

end
