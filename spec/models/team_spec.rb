# == Schema Information
#
# Table name: teams # 小组
#
#  id                    :integer          not null, primary key
#  name                  :string                                 # 名称
#  member_count          :integer                                # 会员数
#  current_donate_amount :decimal(14, 2)   default(0.0)          # 当前捐助金额
#  total_donate_amount   :decimal(14, 2)   default(0.0)          # 捐助总额
#  creater_id            :integer                                # 团队创建人id
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  team_no               :string                                 # 团队编号
#

require 'rails_helper'

RSpec.describe Team, type: :model do
  let!(:user) { create(:user) }
  let!(:team) { create(:team, creater: user) }

  it '测试生成团队编号' do
    expect(team.team_no).to eq 'T000001'
  end
end
