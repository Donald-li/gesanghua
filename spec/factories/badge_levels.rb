# == Schema Information
#
# Table name: badge_levels # 勋章级别
#
#  id         :integer          not null, primary key
#  kind       :integer                                # 类型
#  title      :string                                 # 标题
#  position   :integer                                # 排序
#  value      :integer                                # 获得条件
#  rank       :string                                 # 级别描述
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :badge_level do
    title "MyString"
    value 1
    rank "lv1"
  end
end
