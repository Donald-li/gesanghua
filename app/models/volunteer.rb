# == Schema Information
#
# Table name: volunteers # 志愿者表
#
#  id            :integer          not null, primary key
#  level         :integer                                # 等级
#  major_id      :integer                                # 专业id
#  duration      :integer                                # 服务时长
#  user_id       :integer                                # 用户
#  job_state     :integer                                # 任务状态
#  state         :integer                                # 状态
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  kind          :integer                                # 类型
#  approve_state :integer                                # 认证状态
#  approve_time  :datetime                               # 认证时间
#

class Volunteer < ApplicationRecord
  belongs_to :major, optional: true
  belongs_to :user
  has_many :task_volunteers
  has_many :tasks, through: :task_volunteers

  enum job_state: {available: 1, leave: 2} # 任务状态 1:可接受任务 2:请假
  default_value_for :job_state, 1

  enum state: {enabled: 1, disabled: 2} # 状态 1:启用 2:禁用
  default_value_for :state, 1

  enum kind: {normal: 1, professional: 2} # 类型 1:普通 2:专业
  default_value_for :kind, 1

  enum approve_state: { submit: 1, pass: 2, reject: 3 } # 审核状态：1:审核中 2:申请通过 3:申请不通过
  default_value_for :approve_state, 1

  default_value_for :approve_time, Time.now

  default_value_for :level, 0

  scope :sorted, ->{ order(created_at: :desc) }

end
