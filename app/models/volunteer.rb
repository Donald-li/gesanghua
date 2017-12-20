# == Schema Information
#
# Table name: volunteers # 志愿者表
#
#  id         :integer          not null, primary key
#  level      :integer                                # 等级
#  major_id   :integer                                # 专业id
#  duration   :integer                                # 服务时长
#  user_id    :integer                                # 用户
#  job_state  :integer                                # 任务状态
#  state      :integer                                # 状态
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Volunteer < ApplicationRecord
  belongs_to :major
  belongs_to :user
  has_many :task_volunteers
  has_many :tasks, through: :task_volunteers

  enum job_state: {available: 1, leave: 2} # 任务状态 1:可接受任务 2:请假
  default_value_for :job_state, 1

  enum state: {enabled: 1, disabled: 2} # 状态 1:启用 2:禁用
  default_value_for :state, 1

  default_value_for :level, 0

  scope :sorted, ->{ order(created_at: :desc) }

end
