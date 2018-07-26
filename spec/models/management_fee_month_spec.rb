# == Schema Information
#
# Table name: management_fee_months # 管理费提取
#
#  id         :bigint(8)        not null, primary key
#  month      :string                                 # 月份
#  count      :integer          default(0)            # 项目数
#  fee        :decimal(14, 2)   default(0.0)          # 管理费
#  state      :integer                                # 状态
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ManagementFeeMonth, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
