# == Schema Information
#
# Table name: adjust_records # 分类调整记录
#
#  id             :integer          not null, primary key
#  amount         :decimal(14, 2)   default(0.0)          # 金额
#  user_id        :integer                                # 操作人
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  from_item_id   :integer
#  from_item_type :string
#  to_item_type   :string
#  to_item_id     :integer
#

FactoryBot.define do
  factory :adjust_record do
    from_fund_id 1
    to_fund_id 1
    amount "9.99"
    user_id 1
  end
end
