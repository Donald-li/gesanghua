# == Schema Information
#
# Table name: goods_categories # 物资分类
#
#  id         :integer          not null, primary key
#  name       :string                                 # 名称
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :goods_category do
    name "MyString"
  end
end
