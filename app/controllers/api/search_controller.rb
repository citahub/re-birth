# frozen_string_literal: true

class Api::SearchController < ApplicationController
  before_action :validate_params, except: [:credit_balance, :transfer_tb_balance]
  before_action :validate_platform
  # before_action :validate_sign

  def establish_total_amount
    amount = Tongbao.where(system_id: params[:systemId], transfer_type: "开立").where(timestamp: [params[:startTime]...params[:endTime]]).sum(:amount)
    render json: {establishTotalAmount: amount}
  end

  def establish_summary
    open_tongbaos = OpenTongbao.order(apply_time: :desc).where(system_id: params[:systemId], received: true).where(receive_time: [params[:startTime]...params[:endTime]])
    list = open_tongbaos.map do |open_tongbao|
      {
        transferTbId: open_tongbao.tongbao_id,
        fromEntId: open_tongbao.apply_enterprise_id,
        toEntId: open_tongbao.receive_enterprise_id,
        amount: open_tongbao.creditor_rights_amount,
        establishTime: open_tongbao.receive_time
      }
    end
    render json: {establishSummary: list}
  end

  def transfer_summary
    tongbaos = Tongbao.where(system_id: params[:systemId], transfer_type: ["流转", "融资"]).where(timestamp: [params[:startTime]...params[:endTime]]).order(timestamp: :desc)
    list = tongbaos.map do |tongbao|
      {
        transferId: tongbao.transfer_no,
        fromEntId: tongbao.from_ent_id,
        toEntId: tongbao.hold_ent_id,
        amount: tongbao.amount,
        transferTbId: tongbao.tongbao_id,
        holdTransferTbId: tongbao.hold_id,
        fromHoldTbId: tongbao.from_hold_id,
        transferType: tongbao.transfer_type,
        transferTime: tongbao.timestamp
      }
    end
    pledges = PledgeTongbao.where(system_id: params[:systemId], is_adopt: true).where(accept_time: [params[:startTime]...params[:endTime]]).order(accept_time: :desc)
    pledges.each do |pledge|
      pledge.pledge_tb_id_list.each_with_index do |hold_id, index|
        record = {
          transferId: pledge.pledge_id,
          fromEntId: pledge.apply_enterprise_id,
          toEntId: pledge.receive_enterprise_id,
          amount: pledge.amount_list[index],
          transferTbId: Tongbao.find_by!(system_id: params[:systemId], hold_id: hold_id).tongbao_id,
          holdTransferTbId: hold_id,
          fromHoldTbId: hold_id,
          transferType: "质押",
          transferTime: pledge.accept_time
        }
        list << record
      end
    end
    render json: {transferSummary: list}
  end

  def cash_total_amount
    amount = Tongbao.where(system_id: params[:systemId], redeem_time: [params[:startTime]...params[:endTime]]).sum(:redeem_amount)
    render json: {cashTotalAmount: amount}
  end

  def cash_summary
    tongbaos = Tongbao.where("balance != 0").includes(:open_tongbao).where(system_id: params[:systemId], redeem_time: [params[:startTime]...params[:endTime]]).order(redeem_time: :desc)
    list = tongbaos.map do |tongbao|
      {
        transferTbId: tongbao.tongbao_id,
        fromEntId: tongbao.open_tongbao.apply_enterprise_id,
        cashTime: tongbao.redeem_time,
        tbHolderId: tongbao.hold_ent_id,
        holdTransferTbId: tongbao.hold_id,
        tbAmount: tongbao.balance
      }
    end
    render json: {cashSummary: list}
  end

  def transfer_tb_balance
    tongbaos = Tongbao.where("balance != 0").where(redeem_time: nil, system_id: params[:systemId]).order(timestamp: :desc)
    list = tongbaos.map do |tongbao|
      {
        entId: tongbao.hold_ent_id,
        transferTbId: tongbao.tongbao_id,
        holdTransferTbId: tongbao.hold_id,
        initAmount: tongbao.amount,
        AvailableAmount: tongbao.current_balance,
        transferAmount: (tongbao.amount - tongbao.balance),
        freeze_status: tongbao.freeze_status,
        lockAmount: tongbao.lock_amount.to_i
      }
    end
    render json: {transferTblist: list}
  end

  def credit_balance
    ents = Institution.where("credit_balance >= 0").where(system_id: params[:systemId]).order(updated_at: :desc)
    list = ents.map do |ent|
      {
        entId: ent.institutions_id,
        creditLimit: ent.credit_limit,
        lockAmount: ent.lock_credit.to_i,
        usableAmount: ent.usable_amount,
        freeze_status: (ent.freeze_type == 0 ? "冻结" : "正常"),
        usedAmount: ent.credit_spent.to_i
      }
    end
    render json: {creditBalance: list}
  end

  private

  def validate_params
    if params[:startTime].blank? || params[:endTime].blank?
      return render json: { error_code: 40003, error_message: "开始时间和结束时间不能为空" }
    end
  end

end
