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
#  team_no               :string                                 # 团队编号
#

FactoryBot.define do
  factory :team do
    name {"#{Faker::Name.name}小组"}
    member_count '10'
    current_donate_amount '11.11'
    total_donate_amount '66.55'
  end
end
