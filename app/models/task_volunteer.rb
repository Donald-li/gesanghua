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
#  user_id             :integer                                # 审核人id
#  finish_state        :integer                                # 完成状态1:未完成doing 2:已完成done
#  source              :string                                 # 获得来源
#  kind                :integer                                # 类型
#

class TaskVolunteer < ApplicationRecord
  belongs_to :volunteer
  belongs_to :task, optional: true
  belongs_to :user, optional: true
  has_many :audits, as: :owner # 报名审核

  enum approve_state: {submit: 1, pass: 2, reject: 3} # 报名审核状态 1:待审核 2:通过 3:未通过
  default_value_for :approve_state, 1

  enum kind: {normal: 1, additional: 2}
  default_value_for :kind, 1

  enum finish_state: {doing: 1, to_check: 2, done: 3}
  default_value_for :finish_state, 1
  default_value_for :duration, 0

  scope :sorted, ->{ order(created_at: :desc) }

  counter_culture :volunteer, column_name: proc {|model| model.done? ? 'duration' : nil }, delta_magnitude: proc {|model| model.duration}

end
