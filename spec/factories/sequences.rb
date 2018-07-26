# == Schema Information
#
# Table name: sequences
#
#  id         :bigint(8)        not null, primary key
#  kind       :string
#  prefix     :string
#  value      :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :sequence do
    kind "MyString"
    prefix "MyString"
    value 1
  end
end
