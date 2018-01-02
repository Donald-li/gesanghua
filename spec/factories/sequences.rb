# == Schema Information
#
# Table name: sequences
#
#  id         :integer          not null, primary key
#  kind       :string
#  prefix     :string
#  value      :integer
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
