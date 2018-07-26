# == Schema Information
#
# Table name: audits
#
#  id         :bigint(8)        not null, primary key
#  owner_type :string
#  owner_id   :bigint(8)
#  state      :integer                                # 审核状态 0:待审核 1:通过 2:未通过
#  user_id    :integer                                # 审核人
#  comment    :text                                   # 评语
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :audit do
    
  end
end
