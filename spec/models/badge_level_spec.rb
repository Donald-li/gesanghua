# == Schema Information
#
# Table name: badge_levels # 勋章级别
#
#  id            :integer          not null, primary key
#  kind          :integer                                # 类型
#  title         :string                                 # 标题
#  position      :integer                                # 排序
#  value         :integer                                # 获得条件
#  rank          :string                                 # 级别描述
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  default_level :boolean          default(FALSE)        # 默认徽章
#  description   :string                                 # 徽章描述
#

require 'rails_helper'

RSpec.describe BadgeLevel, type: :model do
  it '判断勋章当前的等级' do
    BadgeLevel.destroy_all
    lv0 = create(:badge_level, kind: :user_donate, title: '一级', value: 0)
    lv1 = create(:badge_level, kind: :user_donate, title: '二级', value: 100)
    lv2 = create(:badge_level, kind: :user_donate, title: '三级', value: 200)
    expect(BadgeLevel.level(:user_donate, 50)).to eq(lv0)
    expect(BadgeLevel.level(:user_donate, 150)).to eq(lv1)
    expect(BadgeLevel.level(:user_donate, 200)).to eq(lv2)
    expect(BadgeLevel.level(:user_donate, 250)).to eq(lv2)
  end

  it 'summary_builder' do
    lv0 = create(:badge_level, kind: :user_donate, title: '一级', value: 0)
    # expect(lv0.summary_builder.keys).to eq(['rank', 'title', 'iconUrl'])
  end
end
