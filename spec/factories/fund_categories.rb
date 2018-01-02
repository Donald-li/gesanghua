# == Schema Information
#
# Table name: fund_categories
#
#  id         :integer          not null, primary key
#  name       :string                                 # 分类名
#  position   :integer                                # 排序
#  amount     :decimal(14, 2)   default(0.0)          # 金额
#  total      :decimal(14, 2)   default(0.0)          # 历史收入
#  describe   :string                                 # 简介
#  state      :integer          default("show")       # 状态 1:显示 2:隐藏
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :fund_category do
    
  end
end
