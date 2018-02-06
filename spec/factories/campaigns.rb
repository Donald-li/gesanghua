# == Schema Information
#
# Table name: campaigns # 活动表
#
#  id                   :integer          not null, primary key
#  name                 :string                                 # 名称
#  price                :decimal(14, 2)   default(0.0)          # 报名费
#  content              :text                                   # 内容
#  start_time           :datetime                               # 预计开始时间
#  end_time             :datetime                               # 预计结束时间
#  sign_up_end_time     :datetime                               # 报名截止时间
#  start_at             :datetime                               # 活动开始时间
#  end_at               :datetime                               # 活动结束时间
#  state                :integer          default("show")       # 状态，1：展示 2：隐藏
#  project_id           :integer                                # 关联项目ID
#  campaign_category_id :integer                                # 活动分类ID
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  sign_up_start_time   :datetime                               # 报名开始时间
#  number               :integer                                # 报名限制人数
#  remark               :string                                 # 报名表备注
#  sign_up_state        :integer                                # 报名状态 1:未开始报名 2:报名中 3:报名结束
#  campaign_state       :integer                                # 活动状态 1:活动未开始 2:活动进行中 3:活动已结束
#

FactoryBot.define do
  factory :campaign do
    name "MyString"
    number 1
    price "9.99"
    content "MyText"
    start_time "2017-12-15 14:38:03"
    end_time "2017-12-15 14:38:03"
    sign_up_end_time "2017-12-15 14:38:03"
    start_at "2017-12-15 14:38:03"
    end_at "2017-12-15 14:38:03"
    state 1
    project_id 1
    campaign_category_id 1
  end
end
