class Api::OuyeController < ApplicationController
  before_action :validate_platform, except: :platforms

  def platforms
    system_ids = Platform.pluck(:system_id)
    render json: {systemIds: system_ids}
  end

  def credit_total
    total_amount = Institution.where(system_id: params[:systemId]).where("credit_limit > 0").sum(:credit_limit).to_6
    used_amount = OpenTongbao.where(redeem_time: nil, received: true, system_id: params[:systemId]).sum(:creditor_rights_amount).to_6
    opening_amount = OpenTongbao.where(system_id: params[:systemId]).applying.sum(:creditor_rights_amount).to_6
    available_amount = (total_amount - used_amount - opening_amount)
    render json: { total_amount: total_amount, available_amount: available_amount, used_amount: used_amount, opening_amount: opening_amount }
  end

  def credit_list
    @ents = Institution.includes(:open_tongbaos).where(system_id: params[:systemId]).where("credit_balance >= 0").order(updated_at: :desc).page(params[:page]).per((params[:per_page] || 10))
    @ents = @ents.where("ent_name like ?", "%#{params["ent_name"]}%") if params["ent_name"].present?
    @ents = @ents.where("institutions_id like ?", "%#{params["ent_id"]}%") if params["ent_id"].present?
  end

  def ent_open_tongbaos
    ent = Institution.find_by(institutions_id: params[:ent_id], system_id: params[:systemId])
    return render({json: {data: []}}) unless ent
    @tongbaos = OpenTongbao.where(create_enterprise_id: ent.id, system_id: params[:systemId]).order(apply_time: :desc)
    @tongbaos = @tongbaos.applying if params["status"] == "开立中"
    @tongbaos = @tongbaos.ended if params["status"] == "开立结束"
    @tongbaos = @tongbaos.where(received: true) if params["status"] == "开立成功"
    @tongbaos = @tongbaos.where(received: [nil, false]).ended if params["status"] == "开立失败"
    @tongbaos = @tongbaos.page(params[:page]).per((params[:per_page] || 10))
  end

  def tongbao_total
    total_amount = Tongbao.where(redeem_time: nil, system_id: params[:systemId]).sum(:balance).to_6
    redeem_amount = Tongbao.where(system_id: params[:systemId]).where("redeem_amount > 0").sum(:redeem_amount).to_6
    origin_lock_amount = Tongbao.where(system_id: params[:systemId]).where("lock_amount > 0").sum(:lock_amount)
    available_amount = (Tongbao.where(system_id: params[:systemId], redeem_time: nil).sum(:balance) - origin_lock_amount).to_6
    render json: { total_amount: total_amount, redeem_amount: redeem_amount, available_amount: available_amount, lock_amount: origin_lock_amount.to_6 }
  end

  def tongbao_list
    @tongbaos = Tongbao.where(system_id: params[:systemId]).order(timestamp: :desc)
    @tongbaos = @tongbaos.where("tongbao_id like ? escape '\\'", "%#{params["open_no"]}%") if params[:open_no].present?
    @tongbaos = @tongbaos.where("hold_id like ? escape '\\'", "%#{params["hold_no"]}%") if params[:hold_no].present?
    if params["ent_name"].present?
      ent_ids = Institution.where(system_id: params[:systemId]).where("ent_name like ?", "%#{params["ent_name"]}%").pluck(:institutions_id)
      @tongbaos = @tongbaos.where(hold_ent_id: ent_ids)
    end
    @tongbaos = @tongbaos.page(params[:page]).per((params[:per_page] || 10))
  end

  def tongbao_detail
    tongbao = Tongbao.find_by!(system_id: params[:systemId], hold_id: params[:hold_no])
    @tongbaos = tongbao.parent_and_sons.where(transfer_type: ["流转", "融资"]).order(timestamp: :desc)
    @tongbaos = @tongbaos.where(transfer_type: params[:transfer_type]) if params[:transfer_type].present?
    @tongbaos = @tongbaos.page(params[:page]).per((params[:per_page] || 10))
  end


end
