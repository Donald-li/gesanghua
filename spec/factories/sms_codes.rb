# == Schema Information
#
# Table name: sms_codes
#
#  id         :integer          not null, primary key
#  kind       :integer
#  mobile     :string
#  code       :string
#  state      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :sms_code do
    kind 1
    mobile "MyString"
    code "MyString"
    state 1
  end
end
