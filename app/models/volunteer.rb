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
#  leave_reason       :jsonb                                  # 请假原因[类型, 说明]
#

# 志愿者
class Volunteer < ApplicationRecord

  belongs_to :user, optional: true
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

  enum kind: {activated: 1, nonactivated: 2} # 志愿者激活状态 1:已激活 2:未激活（导入志愿者）
  default_value_for :kind, 1

  enum internship_state: {official: 1, practice: 2} # 类型 1:实习 2:正式
  default_value_for :internship_state, 1

  enum approve_state: { submit: 1, pass: 2, reject: 3 } # 审核状态：1:审核中 2:申请通过 3:申请不通过
  default_value_for :approve_state, 1

  default_value_for :approve_time, Time.now

  default_value_for :level, 0
  default_value_for :duration, 0
  default_value_for :leave_reason, {type: '', content: ''}

  scope :sorted, ->{ order(created_at: :desc) }

  include HasAsset
  has_one_asset :image, class_name: 'Asset::VolunteerImage'

  before_create :gen_volunteer_apply_no

  def volunteer_name
    self.user.try(:name)
  end

  def leave_reason_content
    "请假原因：#{self.leave_reason['type']} \\n请假说明：#{self.leave_reason['content']}"
  end

  def gen_volunteer_no
    time_string = Time.now.strftime("%y")
    self.volunteer_no ||= Sequence.get_seq(kind: :volunteer_no, prefix: 'ZYZ' + time_string, length: 4)
  end

  def volunteer_state
    if self.enable?
      if self.available?
        '服务中'
      else
        '请假中'
      end
    else
      '身份冻结'
    end
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :volunteer_no, :duration, :kind, :job_state)
      json.user_nickname self.try(:user).try(:nickname)
      json.user_phone self.try(:user).try(:phone)
      json.user_province ChinaCity.get(self.try(:user).try(:province)).to_s
      json.user_city ChinaCity.get(self.try(:user).try(:city)).to_s
      json.state self.volunteer_state
      json.approve_time self.approve_time.strftime("%Y-%m-%d")
      json.practice self.practice? ? '实习中' : ''
      json.avatar_mode self.user.try(:avatar).present?
      json.user_avatar_src self.try(:user).try(:user_avatar)
    end.attributes!
  end

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id, :describe, :workstation)
      json.user_name self.try(:user).try(:name)
      json.user_nickname self.try(:user).try(:nickname)
      json.phone self.phone
      json.user_email self.user.try(:email)
      json.user_qq self.user.try(:qq)
      json.avatar_mode self.user.try(:avatar).present?
      json.avatar do
        json.id self.user.try(:avatar).try(:id)
        json.url self.user.try(:user_avatar)
        json.protect_token self.user.try(:avatar).try(:protect_token)
      end
    end.attributes!
  end

  def apply_builder
    Jbuilder.new do |json|
      json.(self, :id, :phone, :describe, :major_ids)
      json.name self.try(:user).try(:name)
      json.id_card self.user.try(:id_card)
    end.attributes!
  end

  def check_builder
    Jbuilder.new do |json|
      json.(self, :id, :phone)
      json.name self.user.name
      json.kind '志愿者'
    end.attributes!
  end

  def set_user_volunteer
    user = self.user
    return unless user.present?
    unless user.has_role?(:volunteer)
      user.add_role(:volunteer)
      user.save
    end
    true
  end

  private
  def gen_volunteer_apply_no
    time_string = Time.now.strftime("%y%m%d")
    self.volunteer_apply_no ||= Sequence.get_seq(kind: :volunteer_apply_no, prefix: time_string, length: 4)
  end

end
