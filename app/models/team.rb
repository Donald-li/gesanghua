# == Schema Information
#
# Table name: teams # 小组
#
#  id                    :integer          not null, primary key
#  name                  :string                                 # 名称
#  member_count          :integer                                # 会员数
#  current_donate_amount :decimal(14, 2)   default(0.0)          # 当前捐助金额
#  total_donate_amount   :decimal(14, 2)   default(0.0)          # 捐助总额
#  creater_id            :integer                                # 团队创建人id
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Team < ApplicationRecord
  has_one :creater, class_name: 'User', foreign_key: :creater_id

  has_many :users
  has_many :donate_records

end
