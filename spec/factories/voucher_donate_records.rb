# == Schema Information
#
# Table name: voucher_donate_records # 捐赠收据记录表
#
#  id               :integer          not null, primary key
#  voucher_id       :integer                                # 捐赠收据ID
#  donate_record_id :integer                                # 捐赠记录ID
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryBot.define do
  factory :voucher_donate_record do
    voucher_id 1
    donate_record_id 1
  end
end
