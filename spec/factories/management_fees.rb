# == Schema Information
#
# Table name: management_fees # 管理费
#
#  id           :bigint(8)        not null, primary key
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

FactoryBot.define do
  factory :management_fee do
    owner_type "MyString"
    owner_id 1
    amount "9.99"
    fund_id 1
    rate 1.5
    fee "9.99"
    user_id 1
    state 1
  end
end
