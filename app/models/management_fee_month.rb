# == Schema Information
#
# Table name: management_fee_months # 管理费提取
#
#  id         :bigint(8)        not null, primary key
#  month      :string                                 # 月份
#  count      :integer          default(0)            # 项目数
#  fee        :decimal(14, 2)   default(0.0)          # 管理费
#  state      :integer                                # 状态
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ManagementFeeMonth < ApplicationRecord
  has_many :management_fees, dependent: :restrict_with_error

  enum state: {unaccrue: 0, accrued: 2}
  default_value_for :state, 0

  scope :sorted, ->{ order(id: :desc) }
end
