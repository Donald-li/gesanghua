# == Schema Information
#
# Table name: cross_fund_adjustments
#
#  id           :bigint(8)        not null, primary key
#  kind         :integer                                # 类型：1:平台 2:配捐 3:退款
#  from_fund_id :integer                                # 被调整分类
#  to_fund_id   :integer                                # 调整到分类
#  amount       :decimal(14, 2)   default(0.0)          # 调整金额
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe CrossFundAdjustment, type: :model do
end
