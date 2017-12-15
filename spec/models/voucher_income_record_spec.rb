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

require 'rails_helper'

RSpec.describe VoucherIncomeRecord, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
