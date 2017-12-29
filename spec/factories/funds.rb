# == Schema Information
#
# Table name: funds
#
#  id               :integer          not null, primary key
#  name             :string                                 # 基金名
#  position         :integer                                # 排序
#  amount           :decimal(14, 2)   default(0.0)          # 金额
#  total            :decimal(14, 2)   default(0.0)          # 历史收入
#  management_rate  :integer          default(0)            # 管理费率
#  describe         :string                                 # 简介
#  fund_category_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryBot.define do
  factory :fund do
    
  end
end
