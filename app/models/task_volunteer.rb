# == Schema Information
#
# Table name: task_volunteers # 任务的志愿者表
#
#  id                  :integer          not null, primary key
#  task_id             :integer                                # 任务id
#  volunteer_id        :integer                                # 志愿者id
#  comment             :string                                 # 管理员评论
#  achievement_comment :text                                   # 成果描述
#  duration            :integer                                # 时长
#  approve_state       :integer                                # 审核状态
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  finish_time         :datetime                               # 任务完成时间
#  approve_time        :datetime                               # 审核时间
#

class TaskVolunteer < ApplicationRecord
  belongs_to :volunteer
  belongs_to :task, optional: true

  enum approve_state: {submit: 1, pass: 2, reject: 3} #状态 1:待审核 2:通过 3:未通过
  default_value_for :approve_state, 1

  scope :sorted, ->{ order(created_at: :desc) }

end
