# == Schema Information
#
# Table name: majors # 专业表
#
#  id         :bigint(8)        not null, primary key
#  name       :string                                 # 专业名称
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :major do
    name FFaker::Name.name
  end
end
