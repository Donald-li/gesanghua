# == Schema Information
#
# Table name: voucher_donate_records # 捐赠收据捐助记录表
#
#  id               :integer          not null, primary key
#  voucher_id       :integer                                # 捐赠收据ID
#  donate_record_id :integer                                # 捐赠记录ID
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

# 捐赠收据对应的捐款记录
class VoucherDonateRecord < ApplicationRecord
  belongs_to :voucher
  belongs_to :donate_record

end
