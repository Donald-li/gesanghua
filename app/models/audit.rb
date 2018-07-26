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

# 审核表
class Audit < ApplicationRecord
  belongs_to :owner, polymorphic: true, optional: true
  belongs_to :user, optional: true

  enum state: {submit: 1, pass: 2, reject: 3} # 状态：1:待审核 2:通过 3:不通过
  default_value_for :state, 1

  scope :sorted, ->{ order(created_at: :desc) }
end
