# == Schema Information
#
# Table name: month_donate_records # 月捐记录表
#
#  id              :integer          not null, primary key
#  month_donate_id :integer                                # 月捐id
#  amount          :decimal(14, 2)   default(0.0)          # 每期捐助金额
#  period          :integer                                # 期数
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe MonthDonateRecord, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
