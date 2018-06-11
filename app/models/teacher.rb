# == Schema Information
#
# Table name: teachers # 老师表
#
#  id           :integer          not null, primary key
#  name         :string                                 # 老师姓名
#  nickname     :string                                 # 老师昵称
#  user_id      :integer                                # 用户ID
#  school_id    :integer                                # 学校ID
#  kind         :integer          default("teacher")    # 老师类型：1:校长 2:老师
#  phone        :string                                 # 老师电话号码
#  state        :integer          default("show")       # 老师状态: 1:启用 2:禁用
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  id_card      :string                                 # 身份证
#  qq           :string                                 # QQ
#  openid       :string                                 # 微信openid
#  wechat       :string                                 # 微信
#  archive_data :jsonb                                  # 归档旧数据
#

class Teacher < ApplicationRecord
  has_paper_trail only: [:nickname, :name, :user_id, :school_id, :kind, :phone, :id_card, :state, :qq]

  require 'custom_validators'

  belongs_to :school
  belongs_to :user, optional: true
  has_many :project_season_applies
  has_many :teacher_projects, dependent: :destroy
  has_many :projects, through: :teacher_projects

  validates :name, :phone, presence: true
  validates :phone, uniqueness: true
  validates :id_card, shenfenzheng_no: true
  validates :qq, qq: true

  enum state: {show: 1, hidden: 2} # 状态：1:启用 2:禁用
  default_value_for :state, 1

  default_value_for :archive_data, {}

  enum kind: {headmaster: 1, teacher: 2} # 老师类型：1:学校负责人 2:老师

  scope :sorted, -> {order(created_at: :desc)}

  def phone_head
    self.school.contact_telephone[0..3] if self.school.contact_telephone.present?
  end

  def phone_body
    self.school.contact_telephone[4..10] if self.school.contact_telephone.present?
  end

  def get_gender
    return unless self.id_card.present?
    ChinesePid.new(self.id_card).gender == 1 ? '男' : '女'
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :name, :phone)
    end.attributes!
  end

  def can_manage_project?(project_id)
    self.teacher_projects.find_by(project_id: project_id).present? || self.headmaster?
  end

  def identity_teacher_summary_builder
    Jbuilder.new do |json|
      json.merge! summary_builder
      json.school_name self.school.name
      json.kind self.enum_name(:kind)
    end.attributes!
  end

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id)
      json.name self.name
      json.phone self.phone
      json.id_card self.try(:id_card)
      json.qq self.try(:qq)
      json.wechat self.try(:wechat)
      json.teacher_projects do
        json.array! self.teacher_projects do |teacher_project|
          json.id teacher_project.project_id
          json.tit teacher_project.project.name
          json.checked true
        end
      end
    end.attributes!
  end

  def bind_user_by_phone(operator)
    result = false
    notice = ''
    user = User.find_by(phone: self.phone)
    self.transaction do
      if user.present?
        if user.has_role?(:teacher) || user.has_role?(:headmaster)
          result, notice = false, self.user.present? ? "关联用户已经有#{self.user.has_role?(:headmaster) ? '学校负责人' : '教师'}角色" : "手机号已绑定过#{user.has_role?(:headmaster) ? '学校负责人' : '教师'}角色"
          raise ActiveRecord::Rollback
        else
          if self.teacher?
            user.add_role(:teacher)
          else
            user.add_role(:headmaster)
            self.school.update!(user: user)
          end
          user.save!
          self.user = user
        end
      end
      unless self.save
        result = false
        notice = self.errors.values.flatten.join(',')
        raise ActiveRecord::Rollback
      end
      self.create_notification(operator)
      result, notice = true, '操作成功'
    end
    return result, notice
  end

  def update_teacher(params, operator)
    result = false
    notice = ''
    self.transaction do
      begin
        old_user = self.user
        self.update!(params)
        result, notice = old_user.remove_teacher_role(operator) if old_user.present?
      rescue => e
        raise ActiveRecord::Rollback
      end
    end
    return result, notice
  end

  def destroy_teacher(operator)
    result = false
    notice = ''
    self.transaction do
      user = self.user
      result, notice = user.remove_teacher_role(operator) if user.present?
      self.destroy!
    end
    return result, notice
  end

  def admin_create_teacher
    result = false
    notice = ''

    self.transaction do
      if self.user.present?
        user = self.user
        user.add_role(:teacher)
        user.save!
      end
      unless self.save
        result = false
        notice = self.errors.values.flatten.join(',')
        raise ActiveRecord::Rollback
      end
      result = true
    end
    return result, notice
  end

  def create_notification(operator)
    if self.user.present?
      Notification.create(
          kind: 'bind_teacher_by_phone',
          owner: self,
          user_id: self.user.id,
          title: '教师角色关联通知',
          content: "#{operator.name}将您添加为#{self.school}的老师"
      )
    end
  end

end
