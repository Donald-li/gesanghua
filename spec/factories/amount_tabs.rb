# == Schema Information
#
# Table name: amount_tabs # 金额选项卡表
#
#  id             :integer          not null, primary key
#  amount         :decimal(14, 2)   default(0.0)          # 金额
#  alias          :string                                 # 别名
#  state          :integer          default("show")       # 状态 1:显示 2:隐藏
#  donate_item_id :integer                                # 可捐助id
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryBot.define do
  factory :amount_tab do
    
  end
end
