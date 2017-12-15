# == Schema Information
#
# Table name: finance_categories # 财务分类表
#
#  id         :integer          not null, primary key
#  name       :string                                 # 分类名称
#  position   :integer                                # 排序
#  fund_name  :string                                 # 基金名称
#  amount     :decimal(14, 2)   default(0.0)          # 金额
#  describe   :string                                 # 简介
#  ancestry   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FinanceCategory < ApplicationRecord
end
