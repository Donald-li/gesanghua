# == Schema Information
#
# Table name: volunteers # 志愿者表
#
#  id                 :integer          not null, primary key
#  level              :integer                                # 等级
#  duration           :integer                                # 服务时长
#  user_id            :integer                                # 用户
#  job_state          :integer                                # 任务状态
#  state              :integer                                # 状态
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  kind               :integer                                # 类型
#  approve_state      :integer                                # 认证状态
#  approve_time       :datetime                               # 认证时间
#  approve_remark     :text                                   # 审核备注
#  volunteer_no       :string                                 # 志愿者编号
#  volunteer_apply_no :string                                 # 志愿者申请编号
#  internship_state   :integer                                # 实习还是正式
#  describe           :text                                   # 个人简介
#  phone              :string                                 # 手机号
#  workstation        :string                                 # 工作单位
#

FactoryBot.define do
  factory :volunteer do
    
  end
end
