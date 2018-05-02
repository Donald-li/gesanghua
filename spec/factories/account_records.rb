# == Schema Information
#
# Table name: account_records # 账户记录
#
#  id               :integer          not null, primary key
#  user_id          :integer                                # 用户ID
#  kind             :integer                                # 操作类型
#  income_record_id :integer
#  donate_record_id :integer
#  donor_id         :integer
#  amount           :decimal(14, 2)   default(0.0)          # 金额
#  remark           :text                                   # 备注
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryBot.define do
  factory :account_record do
    user_id 1
    kind 1
    income_record_id 1
    donate_record_id 1
    donor_id 1
    amount "9.99"
    remark "MyText"
  end
end
