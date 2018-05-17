# == Schema Information
#
# Table name: management_fees # 管理费
#
#  id           :integer          not null, primary key
#  owner_type   :string                                 # 所属项目
#  owner_id     :integer                                # 所属项目ID
#  total_amount :decimal(14, 2)   default(0.0)          # 项目金额
#  amount       :decimal(14, 2)   default(0.0)          # 提取管理费金额
#  fund_id      :integer                                # 收入分类
#  rate         :float                                  # 费率
#  fee          :decimal(14, 2)   default(0.0)          # 管理费金额
#  user_id      :integer                                # 用户
#  state        :integer                                # 状态
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  month_id     :integer                                # 月份
#

require 'rails_helper'

RSpec.describe ManagementFee, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
