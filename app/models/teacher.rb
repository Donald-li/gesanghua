# == Schema Information
#
# Table name: teachers # 老师表
#
#  id         :integer          not null, primary key
#  name       :string                                 # 老师姓名
#  nickname   :string                                 # 老师昵称
#  user_id    :integer                                # 用户ID
#  school_id  :integer                                # 学校ID
#  kind       :integer          default("teacher")    # 老师类型：1:校长 2:老师
#  phone      :string                                 # 老师电话号码
#  state      :integer          default("show")       # 老师状态: 1:启用 2:禁用
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  id_card    :string                                 # 身份证
#  qq         :string                                 # QQ
#  openid     :string                                 # 微信openid
#
# 教师
class Teacher < ApplicationRecord

  require 'custom_validators'

  belongs_to :school
  belongs_to :user, optional: true
  has_many :project_season_applies
  has_many :teacher_projects, dependent: :destroy
  has_many :projects, through: :teacher_projects

  validates :name, :phone, presence: true
  # validates :phone, uniqueness: true
  validates :id_card, shenfenzheng_no: true
  validates :qq, qq: true

  enum state: {show: 1, hidden: 2} # 状态：1:启用 2:禁用
  default_value_for :state, 1

  enum kind: { headmaster: 1, teacher: 2 } # 老师类型：1:校长 2:老师

  scope :sorted, ->{ order(created_at: :desc) }

  def phone_head
    self.school.contact_telephone[0..3] if self.school.contact_telephone.present?
  end

  def phone_body
    self.school.contact_telephone[4..10] if self.school.contact_telephone.present?
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
      json.openid self.try(:openid)
      json.teacher_projects do
        json.array! self.teacher_projects do |teacher_project|
          json.id teacher_project.project_id
          json.tit teacher_project.project.name
          json.checked true
        end
      end
    end.attributes!
  end

end
