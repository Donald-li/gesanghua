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
#

class Volunteer < ApplicationRecord
  belongs_to :user
  has_many :task_volunteers, dependent: :destroy
  has_many :tasks, through: :task_volunteers
  has_many :volunteer_major_ships
  has_many :majors, through: :volunteer_major_ships
  has_many :audits, as: :owner
  has_many :remarks, as: :owner

  enum job_state: {available: 1, leave: 2} # 任务状态 1:可接受任务 2:请假
  default_value_for :job_state, 1

  enum state: {enable: 1, disable: 2} # 状态 1:启用 2:禁用
  default_value_for :state, 1

  enum kind: {normal: 1, professional: 2} # 类型 1:普通 2:专业
  default_value_for :kind, 1

  enum internship_state: {official: 1, practice: 2} # 类型 1:实习 2:正式
  default_value_for :internship_state, 1

  enum approve_state: { submit: 1, pass: 2, reject: 3 } # 审核状态：1:审核中 2:申请通过 3:申请不通过
  default_value_for :approve_state, 1

  default_value_for :approve_time, Time.now

  default_value_for :level, 0
  default_value_for :duration, 0

  scope :sorted, ->{ order(created_at: :desc) }

  before_create :gen_volunteer_apply_no

  def volunteer_name
    self.user.try(:name)
  end

  def gen_volunteer_no
    time_string = Time.now.strftime("%y")
    self.volunteer_no ||= Sequence.get_seq(kind: :volunteer_no, prefix: 'ZYZ' + time_string, length: 4)
  end

  private
  def gen_volunteer_apply_no
    time_string = Time.now.strftime("%y%m%d")
    self.volunteer_apply_no ||= Sequence.get_seq(kind: :volunteer_apply_no, prefix: time_string, length: 4)
  end

end
