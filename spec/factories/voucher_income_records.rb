# == Schema Information
#
# Table name: voucher_income_records # 捐助收据入账记录表
#
#  id               :integer          not null, primary key
#  voucher_id       :integer                                # 收据ID
#  income_record_id :integer                                # 入账记录ID
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryBot.define do
  factory :voucher_income_record do
    voucher_id 1
    income_record_id 1
  end
end
