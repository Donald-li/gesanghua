# == Schema Information
#
# Table name: operate_logs
#
#  id         :bigint(8)        not null, primary key
#  user_id    :integer
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :operate_log do
    user_id 1
    title "MyString"
  end
end
