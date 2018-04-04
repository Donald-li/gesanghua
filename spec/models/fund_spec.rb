# == Schema Information
#
# Table name: funds
#
#  id               :integer          not null, primary key
#  name             :string                                     # 基金名
#  position         :integer                                    # 排序
#  balance          :decimal(14, 2)   default(0.0)              # 金额
#  total            :decimal(14, 2)   default(0.0)              # 历史收入
#  management_rate  :integer          default(0)                # 管理费率
#  describe         :string                                     # 简介
#  state            :integer          default("show")           # 状态 1:显示 2:隐藏
#  fund_category_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  kind             :integer          default("nondirectional") # 类型 1:非定向 2:定向
#  use_kind         :integer          default("unrestricted")   # 指定类型 1:非指定 2:指定
#

require 'rails_helper'

RSpec.describe Fund, type: :model do
  # it "测试跨分类调整" do
  #   gsh_fund = Fund.gsh
  #   pair_fund = Project.pair_project.fund
  #
  #   gsh_fund.update(amount: 10000)
  #   Fund.platform_adjust(gsh_fund.id, pair_fund.id, 120)
  #   expect(Fund.gsh.amount).to eq (10000 - 120)
  #   expect(Project.pair_project.fund.amount).to eq 120
  # end
end
