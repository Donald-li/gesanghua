# == Schema Information
#
# Table name: expenditure_ledgers # 支出分类
#
#  id         :bigint(8)        not null, primary key
#  name       :string                                 # 名称
#  position   :integer                                # 排序
#  amount     :decimal(14, 2)   default(0.0)          # 合计支出金额
#  describe   :text                                   # 描述
#  state      :integer                                # 状态
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :expenditure_ledger do
    name "MyString"
    positin 1
    amount "9.99"
    describe "MyText"
    state 1
  end
end
