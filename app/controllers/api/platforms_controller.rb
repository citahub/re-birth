class Api::PlatformsController < ApplicationController
 def create
  if params[:system_id].blank?
    return render json: { code: 40301, message: "systemId不能为空" }
  end
  if params[:admin_id].blank? && (params[:auth_address].blank? || params[:auth_private_key].blank?)
    return render json: { code: 40304, message: "请传递转发存证管理员id或授权密钥对参数" }
  end

  platform = Platform.find_or_initialize_by(system_id: params[:system_id])
  if params[:admin_id].present?
    platform.push_admin_id = params[:admin_id]
    platform.begin_push_block = SyncInfo.current_block_number
  end

  if params[:auth_address].present? && params[:auth_private_key].present?
    platform.auth_address = params[:auth_address].sub(/^0[xX]/, '')
    platform.auth_private_key = params[:auth_private_key].sub(/^0[xX]/, '')
  end
  platform.save!

  render json: {code: 0, message: "成功"}
 end
end