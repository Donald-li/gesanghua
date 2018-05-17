# == Schema Information
#
# Table name: management_fee_months # 管理费提取
#
#  id         :integer          not null, primary key
#  month      :string                                 # 月份
#  count      :integer          default(0)            # 项目数
#  fee        :decimal(14, 2)   default(0.0)          # 管理费
#  state      :integer                                # 状态
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :management_fee_month do
    month "MyString"
    fee "9.99"
    state 1
  end
end
