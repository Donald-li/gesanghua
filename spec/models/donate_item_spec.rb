# == Schema Information
#
# Table name: donate_items # 可捐助项目表
#
#  id         :bigint(8)        not null, primary key
#  name       :string                                 # 名称
#  describe   :string                                 # 说明
#  state      :integer                                # 状态： 1：显示 2：隐藏
#  position   :integer                                # 排序
#  fund_id    :integer                                # 基金id
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe DonateItem, type: :model do
  let(:fund_category) { create(:fund_category, name: '自定义物资类', describe: '自定义物资类项目财务分类')}
  let(:fund) { create(:fund, name: '爱心早餐', fund_category: fund_category)}
  let(:donate_item) { create(:donate_item, name:'结对助学', describe: '所捐款项将用于结对助学项目', fund: fund) }
end
