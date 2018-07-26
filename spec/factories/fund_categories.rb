# == Schema Information
#
# Table name: fund_categories
#
#  id         :bigint(8)        not null, primary key
#  name       :string                                     # 分类名
#  position   :integer                                    # 排序
#  amount     :decimal(14, 2)   default(0.0)              # 金额
#  total      :decimal(14, 2)   default(0.0)              # 历史收入
#  describe   :string                                     # 简介
#  state      :integer          default("show")           # 状态 1:显示 2:隐藏
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  kind       :integer          default("nondirectional") # 类型 1:非定向 2:定向
#

FactoryBot.define do
  factory :fund_category do
    name { FFaker::NameCN.name }
    describe '描述'
  end
end
