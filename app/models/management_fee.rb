# == Schema Information
#
# Table name: management_fees # 管理费
#
#  id           :integer          not null, primary key
#  owner_type   :string                                 # 所属项目
#  owner_id     :integer                                # 所属项目ID
#  total_amount :decimal(14, 2)   default(0.0)          # 项目金额
#  amount       :decimal(14, 2)   default(0.0)          # 提取管理费金额
#  fund_id      :integer                                # 收入分类
#  rate         :float                                  # 费率
#  fee          :decimal(14, 2)   default(0.0)          # 管理费金额
#  user_id      :integer                                # 用户
#  state        :integer                                # 状态
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  month_id     :integer                                # 月份
#

class ManagementFee < ApplicationRecord
  belongs_to :owner, polymorphic: true
  belongs_to :fund, optional: true
  belongs_to :user, optional: true
  belongs_to :month, class_name: 'ManagementFeeMonth', optional: true

  enum state: {normal: 1}
  default_value_for :state, 1

  counter_culture :month, column_name: :fee, delta_magnitude: proc {|model| model.fee}
  counter_culture :month, column_name: :count

  before_create :calc_managemeng_rate

  scope :sorted, -> { order(id: :desc) }

  # 计提管理费
  def self.accrue_management_fee(owner_type: '', owner_id: nil, fund_id: nil, total_amount: 0, amount: 0, user: nil)
    month_str = Time.now.strftime('%Y-%m')
    month = ManagementFeeMonth.find_or_create_by(month: month_str)
    item = owner_type.constantize.find(owner_id)
    return false unless item
    return false unless !item.accrued?
    fund = Fund.find(fund_id) if fund_id
    fund ||= item.project.try(:appoint_fund)
    return false unless fund
    result = self.create(month: month, owner: item, total_amount: total_amount, amount: amount, fund_id: fund.id, rate: fund.management_rate, user: user)
    return unless result
    item.accrued!
    true
  end

  # 计算管理费
  def calc_managemeng_rate
    return unless self.fund
    self.rate ||= self.fund.management_rate
    self.fee = self.amount.to_f * self.rate / 100
  end

end
