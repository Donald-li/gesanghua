# == Schema Information
#
# Table name: support_categories # 帮助主题分类
#
#  id         :integer          not null, primary key
#  name       :string                                 # 名称
#  describe   :string                                 # 描述
#  position   :integer                                # 排序
#  state      :integer                                # 状态 1:显示 2:隐藏
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :support_category do
    name "MyString"
    describe "MyString"
    position 1
    state 1
  end
end
