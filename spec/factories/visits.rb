# == Schema Information
#
# Table name: visits # 家访记录表
#
#  id         :integer          not null, primary key
#  owner_id   :integer
#  owner_type :string
#  content    :text                                   # 内容
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :visit do
    owner_id 1
    owner_type "MyString"
    content "MyText"
  end
end