# == Schema Information
#
# Table name: users # 用户
#
#  id                    :integer          not null, primary key
#  openid                :string                                       # 微信openid
#  name                  :string                                       # 姓名
#  login                 :string                                       # 登录账号
#  password_digest       :string                                       # 密码
#  state                 :integer          default("enable")           # 状态 1:启用 2:禁用
#  team_id               :integer                                      # 团队ID
#  profile               :jsonb                                        # 微信profile
#  gender                :integer                                      # 性别，1：男 2：女
#  balance               :decimal(14, 2)   default(0.0)                # 账户余额
#  phone                 :string                                       # 联系方式
#  email                 :string                                       # 电子邮箱地址
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  nickname              :string                                       # 昵称
#  salutation            :string                                       # 孩子们如何称呼我
#  consignee             :string                                       # 收货人
#  province              :string                                       # 省
#  city                  :string                                       # 市
#  district              :string                                       # 区/县
#  address               :string                                       # 详细地址
#  qq                    :string                                       # qq号
#  id_card               :string                                       # 身份证
#  donate_count          :decimal(14, 2)   default(0.0)                # 捐助金额
#  online_count          :decimal(14, 2)   default(0.0)                # 线上捐助金额
#  offline_count         :decimal(14, 2)   default(0.0)                # 线下捐助金额
#  auth_token            :string                                       # Token
#  manager_id            :integer                                      # 线下用户管理人id
#  roles_mask            :integer                                      # 角色
#  kind                  :integer          default("online_user")      # 用户类型 1:平台用户 2:线上用户 3:线下用户
#  phone_verify          :integer          default("phone_unverified") # 手机认证 1:未认证 2:已认证
#  promoter_amount_count :decimal(14, 2)   default(0.0)                # 累计劝捐额
#  use_nickname          :integer                                      # 使用昵称
#  join_team_time        :datetime                                     # 加入团队时间
#  camp_id               :integer                                      # 探索营id
#  project_ids           :jsonb                                        # 可管理项目（项目管理员）
#

# 用户
require 'custom_validators'
class User < ApplicationRecord
  include HasBitEnum
  ROLES = %i[superadmin admin project_manager project_operator financial_staff volunteer county_user gsh_child custom_service headmaster teacher camp_manager]
  ROLES_NAME = %w[超级管理员 管理员 项目管理员 项目操作员 财务人员 志愿者 教育局用户 格桑花孩子 客服 校长 老师 营管理员]
  has_bit_enum :role, ROLES, ROLES_NAME
  scope :admin_user, ->{where("(users.roles_mask::bit(12) & B'100000011111')::integer > 0")}

  attr_accessor :avatar_id

  default_value_for :project_ids, []

  include HasAsset
  has_one_asset :avatar, class_name: 'Asset::UserAvatar'

  belongs_to :team, optional: true
  belongs_to :camp, optional: true

  has_one :school # 校长
  has_one :create_school, class_name: 'School', foreign_key: 'creater_id', dependent: :nullify # 用户创建的学校
  has_one :teacher
  has_one :volunteer
  has_one :county_user
  has_one :gsh_child
  has_many :gsh_child_grants
  has_many :children, class_name: 'ProjectSeasonApplyChild', foreign_key: 'donate_user_id', dependent: :nullify # 我捐助的孩子们
  has_many :vouchers
  has_many :campaign_enlists
  has_many :campaigns, through: :campaign_enlists
  has_many :donate_records, foreign_key: :donor_id, dependent: :nullify
  has_many :donations, dependent: :nullify, foreign_key: 'donor_id'
  has_many :visits

  has_many :income_records, dependent: :nullify, foreign_key: 'donor_id'
  has_many :project_season_applies
  has_many :month_donates

  has_many :offline_users, class_name: "User", foreign_key: "manager_id"

  belongs_to :manager, class_name: "User", optional: true

  validates :password, confirmation: true, length: { minimum: 6 }, allow_blank: true
  default_value_for :password, '111111'
  validates :email, email: true
  validates :phone, mobile: true, uniqueness: { allow_blank: true }
  validates :name, :login, presence: true
  validates :login, uniqueness: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  default_value_for :profile, {}

  enum state: {enable: 1, disable: 2} #状态 1:启用 2:禁用
  default_value_for :state, 1

  enum gender: {male: 1, female: 2} #性别 1:男 2:女
  default_value_for :gender, 1

  enum use_nickname: {anonymous: 1, autonym: 2, designation: 3} #使用昵称 1:匿名（使用昵称） 2:实名使用姓名 3.使用称呼
  default_value_for :use_nickname, 2

  scope :sorted, ->{ order(created_at: :desc) }
  scope :reverse_sorted, ->{ sorted.reverse_order }

  enum kind: {platform_user: 1, online_user: 2, offline_user: 3} # 用户类型 1:平台用户 2:线上用户 3:线下用户

  enum phone_verify: { phone_unverified: 1, phone_verified: 2} # 手机认证 1:未认证 2:已认证

  before_create :generate_auth_token

  has_secure_password

  counter_culture :team, column_name: proc {|model| model.team.present? ? 'member_count' : nil}

  def generate_auth_token
    loop do
      self.auth_token = SecureRandom.base64(64)
      break if !User.find_by(auth_token: auth_token)
    end
  end

  # 生成捐赠证书的名称
  def card_name
    if self.anonymous?
      self.nickname
    elsif self.designation?
      self.salutation
    else
      self.name
    end
  end

  def show_name
    if self.nickname.present?
      self.nickname
    else
      self.name
    end
  end

  # 用户对外显示的名字
  def user_name
    self.show_name
  end

  def user_avatar
    self.avatar.try(:file_url, :tiny) || self.profile["headimgurl"] || self.avatar_url(:tiny)
  end

  def headmaster?
    self.has_role?(:headmaster)
  end

  def teacher?
    self.has_role?(:teacher)
  end

  def county_user?
    self.has_role?(:county_user)
  end

  def volunteer?
    self.has_role?(:volunteer)
  end

  def project_manager?
    self.has_role?(:project_manager)
  end

  def project_operator?
    self.has_role?(:project_operator)
  end

  def gsh_child?
    self.has_role?(:gsh_child)
  end

  # 作为校长或老师管理的项目
  def manage_projects
    return Project.visible if self.headmaster?
    return self.teacher.projects.visible if self.teacher
  end

  def school_role
    if self.headmaster?
      'headmaster'
    elsif self.teacher?
      'teacher'
    else
      'normal'
    end
  end

  def user_balance
    "#{self.name}(可用余额:#{self.balance.to_s})"
  end

  def school_approve_state
    if self.teacher?
      self.teacher.school.approve_state
    elsif self.create_school.present?
      self.create_school.approve_state
    else
      'default'
    end
  end

  def volunteer_approve_state
    self.volunteer.present? ? self.volunteer.approve_state : 'default'
  end

  # 可开票金额
  def to_bill_amount
    self.donations.where({ created_at: (Time.now.beginning_of_year)..(Time.now.end_of_year), voucher_state: 1, pay_state: 2 }).sum(:amount)
  end

  def full_address
    ChinaCity.get(self.province).to_s + ChinaCity.get(self.city).to_s + ChinaCity.get(self.district).to_s + self.adderss.to_s
  end

  def simple_address
    ChinaCity.get(self.province).to_s + " " + ChinaCity.get(self.city).to_s + " " + ChinaCity.get(self.district).to_s
  end

  def short_address
    ChinaCity.get(self.city).to_s + " " + ChinaCity.get(self.district).to_s
  end

  def self.update_user_statistic_record
    time = Time.now
    amount = self.where("created_at > ? and created_at < ?", time.beginning_of_day, time.end_of_day).count
    record = StatisticRecord.find_or_create_by(amount: amount, kind: 1, record_time: time)
    record.update(amount: amount)
  end

  def role_tag
    if self.has_role?(:headmaster)
      '校长'
    elsif self.has_role?(:teacher)
      '教师'
    elsif self.has_role?(:county_user)
      '县教育局'
    elsif self.has_role?(:volunteer)
      '志愿者'
    elsif self.has_role?(:custom_service)
      '工作人员'
    elsif self.donations.present?
      '爱心人士'
    end
  end

  # 扣用户余额
  def deduct_balance(amount)
    self.balance -= amount
    self.save
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :nickname, :balance, :donate_count, :role_tag, :team_id, :phone)
      json.login_name self.login
      json.user_avatar self.user_avatar
      json.promoter_count self.promoter_amount_count
      json.team_name self.team.present? ? self.team.name : ''
      json.join_team_time self.join_team_time.strftime("%Y-%m-%d") if self.join_team_time.present?
      json.roles self.roles
      json.project_ids self.manage_projects.ids if self.headmaster? || self.teacher?
    end.attributes!
  end

  def session_builder
    Jbuilder.new do |json|
      json.merge! summary_builder
      json.auth_token self.auth_token
      json.roles self.roles
      json.project_ids self.manage_projects.ids if self.headmaster? || self.teacher?
      json.has_team self.team.present?
    end.attributes!
  end

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id, :nickname, :team_id, :balance)
      json.login_name self.login
      json.avatar self.user_avatar
      json.name self.name
      json.gender self.gender == 'male'? ['男'] : ['女']
      json.use_nickname [self.use_nickname]
      json.salutation self.salutation
      json.email self.email
      json.location [self.province, self.city, self.district]
      json.address self.address
      json.phone self.phone
      json.has_team self.team.present?
      json.team_name self.team.try(:name)
      json.avatar_image  do
        json.id self.try(:avatar).try(:id)
        json.url self.try(:user_avatar)
        json.protect_token ''
      end
      json.show_name self.nickname.present?? self.nickname : self.name
    end.attributes!
  end

  def offline_donor_summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :phone, :name, :nickname)
      json.show_name self.nickname.present?? self.nickname : self.name
    end.attributes!
  end

  def school_user_summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :phone, :name, :nickname)
      json.school_name self.try(:teacher).try(:school).try(:name)
      json.kind self.try(:teacher).kind == 'headmaster'? '校长' : '教师'
      json.show_name self.nickname.present?? self.nickname : self.name
      json.user_avatar do
        json.id self.try(:avatar).try(:id)
        json.url self.try(:avatar).try(:file_url)
        json.protect_token ''
      end
      json.avatar_src self.user_avatar
    end.attributes!
  end

  # 微信绑定手机号之后，根据手机号合并user记录，绑定volunteer,teacher(headmaster),county_user角色（gsh_child有单独绑定途径）
  def combine_user
    users = User.where(phone: self.phone)
    if users.present?
      # 合并方法（待定）
    end
  end

  def bind_user_roles
    volunteer = Volunteer.find_by(phone: self.phone)
    teacher = Teacher.find_by(phone: self.phone)
    county_user = CountyUser.find_by(phone: self.phone)
    self.bind_user_with_volunteer(volunteer) if volunteer.present?
    self.bind_user_with_teacher(teacher) if teacher.present?
    self.bind_user_with_county_user(county_user) if county_user.present?
  end

  def bind_user_with_volunteer(volunteer)
    self.add_role(:volunteer) unless self.has_role?(:volunteer)
    volunteer.user = self
    volunteer.save
    self.save
  end

  def bind_user_with_teacher(teacher)
    self.add_role(:teacher) if teacher.teacher? && !self.has_role?(:teacher)
    self.add_role(:headmaster) if teacher.headmaster? && !self.has_role?(:headmaster)
    teacher.user = self
    teacher.save
    self.save
  end

  def bind_user_with_county_user(county_user)
    self.add_role(:county_user) unless self.has_role?(:county_user)
    county_user.user = self
    county_user.save
    self.save
  end

  private
  # TODO: 创建用户
  def self.create_user
  end

  # 创建线下用户
  def self.create_offline_user(name, phone, gender, salutation, email, province, city, district, address, nickname, use_nickname)
    User.create(login: phone, name: name, phone: phone, gender: gender, salutation: salutation, email: email, province: province, city: city, district: district, address: address, nickname: nickname, use_nickname: use_nickname)
  end

end
