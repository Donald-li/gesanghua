# == Schema Information
#
# Table name: campaign_categories # 活动分类表
#
#  id         :bigint(8)        not null, primary key
#  name       :string                                 # 名称
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :campaign_category do
    name "MyString"
  end
end
