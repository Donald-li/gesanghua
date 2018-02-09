# == Schema Information
#
# Table name: donations # 可捐助项目表
#
#  id         :integer          not null, primary key
#  name       :string                                 # 名称
#  describe   :string                                 # 说明
#  state      :integer                                # 状态： 1：显示 2：隐藏
#  position   :integer                                # 排序
#  fund_id    :integer                                # 基金id
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Donation, type: :model do
  let(:fund_category) { create(:fund_category, name: '自定义物资类', describe: '自定义物资类项目财务分类')}
  let(:fund) { create(:fund, name: '爱心早餐', fund_category: fund_category)}
  let(:donation) { create(:donation, name:'一对一', describe: '所捐款项将用于一对一项目', fund: fund) }
end
