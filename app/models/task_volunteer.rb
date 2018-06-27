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
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  finish_time         :datetime                               # 任务完成时间
#  approve_time        :datetime                               # 审核时间
#  user_id             :integer                                # 审核人id
#  source              :string                                 # 获得来源
#  kind                :integer                                # 类型
#  reason              :text                                   # 申请理由
#  state               :integer
#

# 任务志愿者关系表
class TaskVolunteer < ApplicationRecord

  after_create :notice_volunteer

  belongs_to :volunteer
  belongs_to :task, optional: true
  belongs_to :user, optional: true
  has_many :audits, as: :owner, dependent: :destroy # 报名审核

  include HasAsset
  has_many_assets :images, class_name: 'Asset::AchievementImage'

  enum state: {submit: 1, pass: 2, reject: 3, to_check: 4, done: 5, turn_over: -1, cancel: -2, apply_cancel: -3} # 报名审核状态 1:待审核 2:通过（进行中） 3:未通过 4.成果已提交 5.任务完成 -1.任务已移交 -2.任务已取消 -3.申请已取消
  default_value_for :state, 1

  enum kind: {normal: 1, appoint: 2}
  default_value_for :kind, 1

  default_value_for :duration, 0

  scope :sorted, ->{ order(created_at: :desc) }

  counter_culture :volunteer, column_name: proc {|model| model.done? ? 'duration' : nil }, delta_column: 'duration'

  def can_turn_over?
    self.pass?
  end

  def can_approve?
    self.submit? || self.pass? || self.reject?
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :duration)
      json.source self.task.try(:name) || self.source
    end.attributes!
  end

  def list_builder
    Jbuilder.new do |json|
      json.(self, :id, :reason)
      json.task_id self.task_id
      json.task_name self.task.try(:name)
      json.task_num self.task.num
      json.task_duration self.task.duration
      json.ordinary_flag self.task.ordinary_flag
      json.intensive_flag self.task.intensive_flag
      json.urgency_flag self.task.urgency_flag
      json.innovative_flag self.task.innovative_flag
      json.difficult_flag self.task.difficult_flag
      json.location self.task.try(:workplace).try(:title)
      json.cover_mode self.task.cover.present?
      json.cover_url self.task.cover_url(:small) if self.task.cover.present?
      json.task_state self.task_state
      json.task_action self.task_action
      json.source self.task.try(:name) || self.task.source
    end.attributes!
  end

  def task_state
    if self.cancel?
      '任务已取消'
    elsif self.apply_cancel?
      '申请已取消'
    elsif self.submit?
      '待审核'
    elsif self.reject?
      '审核未通过'
    elsif self.pass?
      '任务执行中'
    elsif self.turn_over?
      '任务已移交'
    elsif self.to_check?
      '成果已提交'
    elsif self.done?
      '任务已完成'
    end
  end

  def task_action
    if self.submit?
      'can_cancel'
    elsif self.pass?
      'can_finish'
    elsif self.reject?
      'can_retry'
    end
  end

  def notice_volunteer
    self.volunteer.update(task_state: true)
  end

end
