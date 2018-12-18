# == Schema Information
#
# Table name: expenditure_ledgers # 财务分类
#
#  id         :bigint(8)        not null, primary key
#  name       :string                                 # 名称
#  position   :integer                                # 排序
#  amount     :decimal(14, 2)   default(0.0)          # 合计支出金额
#  describe   :text                                   # 描述
#  state      :integer                                # 状态
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ExpenditureLedger, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
