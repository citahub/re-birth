class Tongbao < ApplicationRecord
  self.primary_key = %i(system_id hold_id)

  belongs_to :open_tongbao, foreign_key: %i(system_id tongbao_id), class_name: "OpenTongbao", primary_key: %i(system_id tongbao_id), inverse_of: :tongbaos, optional: true
  belongs_to :from_ent, foreign_key: %i(system_id from_ent_id), class_name: "Institution", optional: true
  belongs_to :hold_ent, foreign_key: %i(system_id hold_ent_id), class_name: "Institution", optional: true

  before_create :set_attrs_from_tongbao
  after_create :update_from_tongbao_balance

  def set_attrs_from_tongbao
    return if self.from_hold_id.blank?
    from_tongbao = Tongbao.find_by!(system_id: system_id, hold_id: from_hold_id)
    self.tongbao_id = from_tongbao.tongbao_id
    self.from_ent_id = from_tongbao.hold_ent_id
  end

  def update_from_tongbao_balance
    return if self.from_hold_id.blank?
    sons_tongbao_amount = Tongbao.where(system_id: system_id, from_hold_id: from_hold_id).sum(:amount)
    from_tongbao = Tongbao.find_by!(system_id: system_id, hold_id: from_hold_id)
    from_tongbao.update!(balance: (from_tongbao.amount - sons_tongbao_amount))
  end

  def circulation_tongbao
    return nil unless transfer_type == "流转"
    CirculationTongbao.find_by!(system_id: system_id, transfer_id: transfer_no)
  end

  def financing_tongbao
    return nil unless transfer_type == "融资"
    FinancingTongbao.find_by!(system_id: system_id, financing_id: transfer_no)
  end

  def operator_id
    case transfer_type
    when "流转"
      circulation_tongbao && circulation_tongbao.extra_data["fromOperatorId"]
    when "融资"
      financing_tongbao && financing_tongbao.extra_data["applyOperatorId"]
    when "开立"
      open_tongbao.extra_data && open_tongbao.extra_data["fromOperatorId"]
    end
  end

  def freeze_status
    return "已兑付" if redeem_time.present?
    return "预兑付冻结" if pre_redeem_time.present?
    return "异常冻结" if freeze_block_number.to_i > unfreeze_block_number.to_i
    "正常"
  end

  def descendant_tongbaos(tongbaos=[])
    son_tongbaos = Tongbao.where(system_id: system_id, from_hold_id: self.hold_id).to_a
    tongbaos << self
    unless son_tongbaos.size == 0
      son_tongbaos.each do |tongbao|
        tongbaos = tongbao.descendant_tongbaos(tongbaos)
      end
    end
    tongbaos
  end

  def parent_and_sons
    return Tongbao.where("system_id = '#{self.system_id}' AND (hold_id = '#{self.hold_id}' OR from_hold_id = '#{self.hold_id}')") if self.from_hold_id.blank?
    Tongbao.where("system_id = '#{self.system_id}' AND (hold_id = '#{self.hold_id}' OR hold_id = '#{self.from_hold_id}' OR from_hold_id = '#{self.hold_id}')")
  end

  def current_balance
    return (balance - redeem_amount) if redeem_time.present?
    return (balance - lock_amount.to_i)
  end

end
