# == Schema Information
#
# Table name: child_trails # 孩子轨迹表
#
#  id            :integer          not null, primary key
#  kind          :integer                                # 分类，1：奖项 2：毕业 3：工作
#  content       :text                                   # 详情
#  awarding_body :string                                 # 操作单位
#  awarding_at   :datetime                               # 操作时间
#  child_id      :integer                                # 孩子ID
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :child_trail do
    kind 1
    content "MyText"
    awarding_body "MyString"
    awarding_at "2017-12-15 15:07:26"
  end
end
