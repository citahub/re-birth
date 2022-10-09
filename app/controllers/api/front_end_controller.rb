# frozen_string_literal: true

class Api::FrontEndController < ApplicationController
  # before_action :validate_sign
  before_action :validate_platform

  def hold_list
    open_tongbao = OpenTongbao.find_by(system_id: params[:systemId], tongbao_id: params[:tongbao_id])

    return render({json: {error_code: 40020, error_message: "无此开立记录"}}) unless open_tongbao
    return render({json: {error_code: 40021, error_message: "平台审核未通过"}}) if open_tongbao.platform_agreed == false
    return render({json: {error_code: 40022, error_message: "核心企业复核未通过"}}) if open_tongbao.enterprise_agreed == false
    return render({json: {error_code: 40023, error_message: "供应商接收接口拒绝接收"}}) if open_tongbao.received == false
    return render({json: {error_code: 40024, error_message: "开立撤销"}}) if open_tongbao.cancel_time.present?
    return render({json: {error_code: 40025, error_message: "授信已退回"}}) if open_tongbao.back_creditor_time.present?
    return render({json: {error_code: 40026, error_message: "平台取消债权开立"}}) if open_tongbao.refuse_time.present?
    return render({json: {error_code: 40027, error_message: "平台还未审核"}}) if open_tongbao.platform_time.blank?
    return render({json: {error_code: 40028, error_message: "非快速开立，核心企业还未复核"}}) if !open_tongbao.is_quick && open_tongbao.enterprise_time.blank?
    return render({json: {error_code: 40029, error_message: "供应商未接收"}}) if open_tongbao.receive_time.blank?

    list = open_tongbao.tongbaos.order(timestamp: :desc).map do |tongbao|
      result = tongbao.as_json.slice("hold_id", "amount", "balance", "from_hold_id", "transfer_type", "redeem_amount")
      result["institutions_id"] = tongbao.hold_ent_id
      result["redeem_time"] = tongbao.redeem_time.try(:timestamp_to_time)
      result["pre_redeem_time"] = tongbao.pre_redeem_time.try(:timestamp_to_time)
      result["transfer_at"] = tongbao.timestamp.timestamp_to_time
      result
    end
    render json: {hold_list: list, open_amount: open_tongbao.creditor_rights_amount}
  end

  def transfer_list
    return render({json: {error_code: 40030, error_message: "参数 hold_ids 不能为空"}}) if params[:hold_ids].blank?
    tongbaos = Tongbao.where(system_id: params[:systemId], hold_id: params[:hold_ids])
    unlock_tongbao_ids = {}
    PledgeTongbao.where(system_id: params[:systemId]).
                  where("pledge_tb_id_list && ARRAY[?]::varchar[]", params[:hold_ids]).
                  where(cancel_time: nil).where(is_adopt: [true, nil]).
                  select(:pledge_id, :pledge_tb_id_list, :unlock_hold_ids, :is_adopt).each do |pledge|
      (pledge.pledge_tb_id_list - pledge.unlock_hold_ids.to_a).each do |hold_id|
        unlock_tongbao_ids[hold_id] = { pledge_id: pledge.pledge_id }
        unlock_tongbao_ids[hold_id][:pledge_status] = (pledge.is_adopt ? "1" : "0")
      end
    end
    list = tongbaos.map do |tongbao|
      holder = {hold_id: tongbao.hold_id, tongbao_id: tongbao.tongbao_id}
      holder["pledge_id"] = unlock_tongbao_ids[tongbao.hold_id][:pledge_id] if unlock_tongbao_ids[tongbao.hold_id]
      holder["pledge_status"] = unlock_tongbao_ids[tongbao.hold_id][:pledge_status] if unlock_tongbao_ids[tongbao.hold_id]

      holder[:transfer_list] = []
      CirculationTongbao.where(system_id: params[:systemId]).applying.where("? = ANY (transfer_tb_id_list)", tongbao.hold_id).each do |circulation_tongbao|
        transfer = {
          transfer_no: circulation_tongbao.transfer_id,
          transfer_type: "流转",
          hold_ids: circulation_tongbao.transfer_tb_id_list,
        }
        holder[:transfer_list] << transfer
      end

      FinancingTongbao.where(system_id: params[:systemId]).applying.where("? = ANY (hold_transfer_tb_id_list)", tongbao.hold_id).each do |financing_tongbao|
        transfer = {
          transfer_no: financing_tongbao.financing_id,
          transfer_type: "融资",
          hold_ids: financing_tongbao.hold_transfer_tb_id_list,
        }
        holder[:transfer_list] << transfer
      end

      holder
    end

    render json: {data: list}
  end

end
