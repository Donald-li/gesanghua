# == Schema Information
#
# Table name: logistics # 物流表
#
#  id         :integer          not null, primary key
#  name       :string                                 # 物流公司
#  number     :string                                 # 物流单号
#  owner_type :string
#  owner_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :logistic do
    name "MyString"
    number "MyString"
    owner_type "MyString"
    owner_id 1
  end
end
