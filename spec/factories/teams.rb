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
#  kind                  :integer                                # 分类：社会（society）高校（college）
#  province              :string                                 # 省
#  city                  :string                                 # 市
#  district              :string                                 # 区县
#  address               :string                                 # 详细地址
#  describe              :text                                   # 简介
#  school_name           :string                                 # 高校名称
#  manage_id             :integer                                # 负责人
#

FactoryBot.define do
  factory :team do
    name {"#{Faker::Name.name}小组"}
    member_count '10'
    current_donate_amount '11.11'
    total_donate_amount '66.55'
  end
end
