# == Schema Information
#
# Table name: cross_fund_adjustments
#
#  id           :integer          not null, primary key
#  kind         :integer                                # 类型：1:平台 2:配捐 3:退款
#  from_fund_id :integer                                # 被调整分类
#  to_fund_id   :integer                                # 调整到分类
#  amount       :decimal(14, 2)   default(0.0)          # 调整金额
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class CrossFundAdjustment < ApplicationRecord
  belongs_to :from_fund, class_name: 'Fund', foreign_key: 'from_fund_id'
  belongs_to :to_fund, class_name: 'Fund', foreign_key: 'to_fund_id'

  validates :amount, presence: true

  enum kind: {platform: 1, donate: 2, refund: 3} # 类型：1:平台 2:配捐 3:退款

  def self.create_platform(from_fund, to_fund, amount)
    return false unless form.present?
    return false unless to.present?
    return false if amount < 1
    self.create(kind: 'platform', from_fund: from_fund, to_fund: to_fund, amount: amount)
  end
end
