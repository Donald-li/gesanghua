# == Schema Information
#
# Table name: finance_categories # 财务分类表
#
#  id         :integer          not null, primary key
#  name       :string                                 # 名称
#  position   :integer                                # 排序
#  fund_name  :string                                 # 基金名称
#  amount     :decimal(14, 2)   default(0.0)          # 金额
#  describe   :string                                 # 简介
#  ancestry   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :finance_category do
    name "MyString"
    position 1
    fund_name "MyString"
    amount "9.99"
    describe "MyString"
    ancestry "MyString"
  end
end
