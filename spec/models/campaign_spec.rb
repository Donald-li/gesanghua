# == Schema Information
#
# Table name: campaigns # 活动表
#
#  id                   :bigint(8)        not null, primary key
#  name                 :string                                 # 名称
#  price                :decimal(14, 2)   default(0.0)          # 报名费
#  content              :text                                   # 内容
#  start_time           :datetime                               # 预计开始时间
#  end_time             :datetime                               # 预计结束时间
#  sign_up_end_time     :datetime                               # 报名截止时间
#  state                :integer          default("show")       # 状态，1：展示 2：隐藏
#  project_id           :integer                                # 关联项目ID
#  campaign_category_id :integer                                # 活动分类ID
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  sign_up_start_time   :datetime                               # 报名开始时间
#  number               :integer                                # 报名限制人数
#  remark               :string                                 # 报名表备注
#  form                 :jsonb                                  # 报名表单定义
#  execute_state        :integer                                # 执行状态
#  appoint_fund_id      :integer                                # 指定财务分类
#  creator_id           :integer
#  child_price          :decimal(14, 2)   default(0.0)          # 儿童价
#

require 'rails_helper'

RSpec.describe Campaign, type: :model do
  
end
