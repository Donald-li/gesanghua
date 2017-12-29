# == Schema Information
#
# Table name: finance_categories # 财务分类表
#
#  id              :integer          not null, primary key
#  name            :string                                 # 分类名称
#  position        :integer                                # 排序
#  fund_name       :string                                 # 基金名称
#  amount          :decimal(14, 2)   default(0.0)          # 金额
#  total           :decimal(14, 2)   default(0.0)          # 历史收入
#  management_rate :integer          default(0)            # 管理费率
#  describe        :string                                 # 简介
#  ancestry        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe FinanceCategory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
