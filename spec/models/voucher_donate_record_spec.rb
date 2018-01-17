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

require 'rails_helper'

RSpec.describe VoucherDonateRecord, type: :model do
  
end
