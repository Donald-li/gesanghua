# == Schema Information
#
# Table name: schools # 学校表
#
#  id                :integer          not null, primary key
#  name              :string                                 # 学校名称
#  address           :string                                 # 地址
#  approve_state     :integer          default("submit")     # 审核状态：1:待审核 2:通过 3:不通过
#  approve_remark    :text                                   # 审核备注
#  province          :string                                 # 省
#  city              :string                                 # 市
#  district          :string                                 # 区/县
#  number            :integer                                # 学校人数
#  describe          :text                                   # 学校简介
#  state             :integer          default("enable")     # 学校状态：1:启用 2:禁用
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  level             :integer                                # 学校等级： 1:初中 2:高中
#  contact_name      :string                                 # 联系人
#  contact_phone     :string                                 # 联系方式
#  contact_position  :string                                 # 联系人职务
#  kind              :integer                                # 学校类型
#  user_id           :integer                                # 校长ID
#  school_no         :string                                 # 学校申请编号
#  contact_id_card   :string                                 # 联系人身份证号
#  postcode          :string                                 # 邮政编码
#  teacher_count     :integer                                # 教师人数
#  logistic_count    :integer                                # 后勤人数
#  contact_telephone :string                                 # 联系人座机号码
#  creater_id        :integer                                # 申请人ID
#  total_amount      :integer                                # 累计获捐
#

# 学校
class School < ApplicationRecord

  has_paper_trail only: [:name, :approve_state, :approve_remark, :contact_name, :contact_phone, :contact_position, :contact_telephone, :contact_id_card, :postcode, :province, :city, :district, :address, :describe, :state, :level, :kind, :user_id]

  require 'custom_validators'

  attr_accessor :logo_id

  include HasAsset
  has_one_asset :logo, class_name: 'Asset::SchoolLogo'
  has_one_asset :card_image, class_name: 'Asset::SchoolCardImage'
  has_one_asset :certificate_image, class_name: 'Asset::SchoolCertificateImage'
  has_many_assets :images, class_name: 'Asset::SchoolImage'

  has_many :bookshelves, class_name: 'ProjectSeasonApplyBookshelf', dependent: :restrict_with_error

  # has_many :supplements, class_name: 'BookshelfSupplement', foreign_key: 'project_season_apply_id', dependent: :restrict_with_error
  has_many :teachers, dependent: :destroy
  # has_many :book_shelves
  has_many :project_season_applies, dependent: :restrict_with_error
  # has_many :gsh_children, dependent: :restrict_with_error
  has_many :audits, as: :owner, dependent: :destroy
  has_many :donate_records
  belongs_to :user, optional: true # 校长user
  belongs_to :creater, class_name: 'User', foreign_key: :creater_id, optional: true
  has_many :apply_camps, class_name: 'ProjectSeasonApplyCamp', dependent: :restrict_with_error

  validates :name, :province, :city, :district, presence: true
  validates :contact_phone, mobile: true
  validates :contact_id_card, shenfenzheng_no: true

  enum state: {enable: 1, disable: 2} # 状态：1:启用 2:禁用
  default_value_for :state, 1

  enum level: {junior: 1, senior: 2} # 学校等级：1:初中 2:高中
  default_value_for :level, 1

  enum kind: {village_center_school: 1, small_village_village: 2, cheng_guan_primary_school: 3, other: 4} # 学校类型：1:乡村中心校 2:乡村村小 3:城关小学 4:其他

  enum approve_state: {submit: 1, pass: 2, reject: 3} # 审核状态：1:待审核 2:审核通过 3：审核不通过
  default_value_for :approve_state, 1

  scope :sorted, ->{ order(created_at: :desc) }

  scope :can_check, ->{ where.not(approve_state: 2) }

  before_create :gen_school_no

  def full_address
    ChinaCity.get(self.province).to_s + ChinaCity.get(self.city).to_s + ChinaCity.get(self.district).to_s + self.address.to_s
  end

  def simple_address
    ChinaCity.get(self.province).to_s + " " + ChinaCity.get(self.city).to_s + " " + ChinaCity.get(self.district).to_s
  end

  def short_address
    ChinaCity.get(self.city).to_s + " " + ChinaCity.get(self.district).to_s
  end

  # 更换校长
  def change_school_user(user)
    return if user == self.user
    # 如果之前学校有校长，并且有教师角色，把角色改成教师
    if self.user.present?
      t = self.user.teacher
      t.update(kind: 'teacher') if t.present?
      u = self.user
      u.remove_role(:headmaster)
      u.add_role(:teacher)
      u.save
    end

    # 将新用户设置为校长
    if user.present?
      if user.teacher.present?
        user.teacher.update(kind: 'headmaster', school_id: self.id)
      else
        Teacher.create(name: self.contact_name, phone: self.contact_phone, id_card: self.contact_id_card, school: self, user: user, kind: 'headmaster')
      end
      user.add_role(:headmaster)
      user.remove_role(:teacher)
      user.save
    else
      # self.update(user_id: nil)
      self.teachers.find_by(kind: 'headmaster').update(kind: 'teacher') if self.teachers.find_by(kind: 'headmaster').present?
    end

    self.update(user: user)
  end

  # 判断学校是否可以新增申请
  def can_new_apply?(project)
    return unless project.present?
    return unless project.user_apply?
    seasons = project.seasons.enable
    applied_seasons_count = ProjectSeasonApply.where(school_id: self.id, project_id: project.id).pluck(:project_season_id).uniq.count
    if project == Project.read_project
      if applied_seasons_count >= seasons.count
        return {can_apply: false, can_supply: false}
      else
        if self.bookshelves.pass_done.present?
          return {can_apply: true, can_supply: true}
        else
          return {can_apply: true, can_supply: false}
        end
      end
    elsif project == Project.movie_project || project == Project.movie_care_project || project.goods?
      if applied_seasons_count >= seasons.count
        return false
      else
        return true
      end
    end
  end

  #学校在执行项目数量
  def school_executing_project_number
    num = 0
    Project.all.each do |project|
      num += self.school_executing_applies(project).count
    end
    num
  end

  #学校已完成项目数量
  def school_done_project_number
    num = 0
    Project.all.each do |project|
      num += self.school_done_applies(project).count
    end
    num
  end

  def school_executing_applies(project)
    if project == Project.pair_project
      ProjectSeasonApply.where(school: self, project: project, pair_state: ['waiting_upload', 'waiting_check'])
    elsif project == Project.read_project
      ProjectSeasonApply.where(school: self, project: project, read_state: 'read_executing')
    elsif project == Project.movie_project || project == Project.movie_care_project
      ProjectSeasonApply.where(school: self, project: project, audit_state: ['submit', 'reject'])
    elsif project.goods?
      ProjectSeasonApply.where(school: self, project: project, execute_state: ['raising', 'to_delivery', 'to_receive', 'to_feedback', 'feedbacked'])
    elsif project == Project.camp_project
      ProjectSeasonApplyCamp.where(school: self, execute_state: ['to_submit', 'to_approve'])
    end
  end

  def school_done_applies(project)
    if project == Project.pair_project
      ProjectSeasonApply.where(school: self, project: project, pair_state: 'pair_complete')
    elsif project == Project.read_project
      ProjectSeasonApply.where(school: self, project: project, read_state: 'read_done')
    elsif project == Project.movie_project || project == Project.movie_care_project
      ProjectSeasonApply.where(school: self, project: project, audit_state: 'pass')
    elsif project.goods?
      ProjectSeasonApply.where(school: self, project: project, execute_state: 'done')
    elsif project == Project.camp_project
      ProjectSeasonApplyCamp.where(school: self, execute_state: 'approved')
    end
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :name)
      json.kind '学校负责人'
      json.user_nickname self.try(:user).try(:nickname)
      json.user_name self.try(:user).try(:name)
      json.contact_telephone self.try(:contact_telephone)
      json.user_avatar do
        json.id self.try(:user).try(:avatar).try(:id)
        json.url self.try(:user).try(:user_avatar)
        json.protect_token self.try(:user).try(:avatar).try(:protect_token)
      end
      json.avatar_src self.try(:user).try(:user_avatar)
      json.avatar_mode self.try(:user).try(:avatar).present?
    end.attributes!
  end

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id, :contact_name, :contact_id_card, :contact_phone, :contact_telephone)
      json.name self.name
      json.address self.address
      json.location [self.province, self.city, self.district]
      json.postcode self.postcode
      json.student_count self.number
      json.teacher_count self.teacher_count
      json.logistic_count self.logistic_count
      json.describe self.describe
      json.logo_src self.try(:logo).try(:file_url)
      json.logo_mode self.try(:logo).present?
      json.logo do
        json.id self.try(:logo).try(:id)
        json.url self.try(:logo).try(:file_url)
        json.protect_token ''
      end
      json.card_image do
        json.id self.try(:card_image).try(:id)
        json.url self.card_image_url(:small).to_s
      end
      json.certificate_image do
        json.id self.try(:certificate_image).try(:id)
        json.url self.certificate_image_url(:small).to_s
      end
      json.executing_project_number self.school_executing_project_number
      json.total_amount self.total_amount
    end.attributes!
  end

  def apply_builder
    Jbuilder.new do |json|
      json.(self, :id, :name)
    end.attributes!
  end

  # def gen_school_user
  #   Teacher.create(name: self.contact_name, school: self, kind: 'headmaster', phone: self.contact_phone, id_card: self.contact_id_card)
  # end
  #
  private
  def gen_school_no
    time_string = Time.now.strftime("%y")
    self.school_no ||= Sequence.get_seq(kind: :school_no, prefix: time_string, length: 5)
  end

end
