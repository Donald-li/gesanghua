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
#  donate_amount         :decimal(14, 2)   default(0.0)                # 捐助金额
#  online_amount         :decimal(14, 2)   default(0.0)                # 线上捐助金额
#  offline_amount        :decimal(14, 2)   default(0.0)                # 线下捐助金额
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
#  notice_state          :boolean          default(FALSE)              # 用户是否有未查看的公告
#  archive_data          :jsonb                                        # 归档旧数据
#  actived_at            :datetime                                     # 激活时间
#

# 用户
require 'custom_validators'
class User < ApplicationRecord

  has_paper_trail only: [:nickname, :name, :password_digest, :state, :gender, :balance, :phone, :email, :address, :salutation, :consignee, :province, :city, :district, :id_card, :qq, :kind, :phone_verify, :use_nickname]

  include HasBitEnum
  ROLES = %w[superadmin admin project_manager project_operator financial_staff volunteer county_user gsh_child custom_service headmaster teacher camp_manager]
  ROLES_HASH = Hash[*ROLES.zip(%w[超级管理员 管理员 项目管理员 项目操作员 财务人员 志愿者 教育局用户 格桑花孩子 客服人员 学校负责人 老师 营管理员]).flatten]
  USER_ROLES = %w[volunteer county_user gsh_child headmaster teacher camp_manager]
  ADMIN_ROLES = %w[superadmin admin project_manager project_operator financial_staff custom_service]
  has_bit_enum :role, ROLES, ROLES_HASH

  scope :admin_user, -> {where("(users.roles_mask::bit(12) & B'100100011111')::integer > 0")}

  attr_accessor :avatar_id
  attr_accessor :new_user_id

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
  has_many :donate_records, foreign_key: :agent_id, dependent: :nullify
  has_many :donations, dependent: :nullify, foreign_key: 'agent_id'
  has_many :income_records, dependent: :nullify, foreign_key: 'agent_id'
  has_many :visits
  has_many :account_records

  has_many :project_season_applies
  has_many :month_donates

  has_many :offline_users, class_name: "User", foreign_key: "manager_id"
  has_many :administrator_logs, dependent: :destroy
  has_many :exception_records, dependent: :nullify

  belongs_to :manager, class_name: "User", optional: true

  has_secure_password validations: false

  validates :password, confirmation: true, allow_blank: true, unless: Proc.new {|u| u.password.present?}
  validates :password, length: {minimum: 6}, allow_blank: true, unless: Proc.new {|u| u.password.present?}
  # default_value_for :password, '111111'
  validates :email, email: true, unless: Proc.new {|u| u.archive_data.present?}
  validates :phone, mobile: true, uniqueness: {allow_blank: true}, unless: Proc.new {|u| u.archive_data.present?}
  # validates :name, presence: true
  validates :login, uniqueness: true, if: Proc.new {|u| u.login.present?}
  validates :balance, numericality: {greater_than_or_equal_to: 0}

  default_value_for :profile, {}

  default_value_for :archive_data, {}

  enum state: {unactived: 0, enable: 1, disable: 2} #状态 0: 未激活（代捐人） 1:启用 2:禁用
  default_value_for :state, 1

  enum gender: {unknow: 0, male: 1, female: 2} #性别 1:男 2:女
  default_value_for :gender, 0

  enum use_nickname: {anonymous: 1, autonym: 2} #使用昵称 1:匿名（使用昵称） 2:实名使用姓名
  default_value_for :use_nickname, 2

  scope :sorted, -> {order(created_at: :desc)}
  scope :reverse_sorted, -> {sorted.reverse_order}

  enum kind: {platform_user: 1, online_user: 2, offline_user: 3} # 用户类型 1:平台用户 2:线上用户 3:线下用户

  enum phone_verify: {phone_unverified: 1, phone_verified: 2} # 手机认证 1:未认证 2:已认证

  before_create :generate_auth_token, :gen_actived_time
  before_save :set_actived_time

  counter_culture :team, column_name: proc {|model| model.team.present? ? 'member_count' : nil}

  def self.find_by_login(login)
    return nil if login.blank?
    case login
      when /\S+@\S+\.\S+/
        self.find_by(email: login)
      when /1\d{10}/
        self.find_by(phone: login)
      else
        self.find_by(openid: login)
    end
  end

  def school
    self.teacher.try(:school)
  end

  def school_name
    self.school.try(:name)
  end

  def bind_wechat?
    # 有微信账号，且已设置密码。
    self.password_digest.present? && self.openid.present?
  end

  def generate_auth_token
    loop do
      self.auth_token = SecureRandom.base64(64)
      break if !User.find_by(auth_token: auth_token)
    end
  end

  def set_actived_time
    if self.state_changed?(from: 'unactived', to: 'enable')
      self.actived_at = Time.now
    end
  end

  def gen_actived_time
    if self.enable?
      self.actived_at = Time.now
    end
  end

  # 生成捐赠证书的名称
  def card_name
    return self.nickname.presence || self.name if self.anonymous?
    return self.name.presence || self.nickname if self.autonym?
  end

  # 显示名称，有昵称显示昵称，没有显示真实姓名
  def show_name
    self.nickname.presence || self.name
  end

  def real_name
    self.name.presence || self.nickname
  end

  def name_for_select
    "#{self.name}（#{self.phone}）"
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
    return Project.where('1<>1') # 空ralation
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
      self.teacher.try(:school).try(:approve_state)
    elsif self.create_school.present?
      self.create_school.approve_state
    else
      'default'
    end
  end

  def volunteer_approve_state
    self.volunteer.present? ? self.volunteer.approve_state : 'default'
  end

  # # 累计捐助金额
  # def donate_amount
  #   self.donate_records.sum(:amount)
  # end

  # 可开票金额
  def to_bill_amount
    self.donations.where({created_at: (Time.now.beginning_of_year)..(Time.now.end_of_year), voucher_state: 1, pay_state: 2}).sum(:amount)
  end

  def full_address
    ChinaCity.get(self.province).to_s + ChinaCity.get(self.city).to_s + ChinaCity.get(self.district).to_s + self.address.to_s
  end

  def simple_address
    ChinaCity.get(self.province).to_s + " " + ChinaCity.get(self.city).to_s + " " + ChinaCity.get(self.district).to_s
  end

  def short_address
    ChinaCity.get(self.city).to_s + " " + ChinaCity.get(self.district).to_s
  end

  def self.update_user_statistic_record
    time = Time.now
    count = self.where("actived_at >= ? and actived_at <= ?", time.beginning_of_day, time.end_of_day).count
    record = StatisticRecord.find_or_create_by(kind: 1, record_time: time.beginning_of_day)
    record.update(amount: count)
  end

  # 更新全部用户注册统计记录
  def self.update_user_history_record
    user_records = self.where.not(actived_at: nil).group_by {|user| user.actived_at.strftime("%Y-%m-%d")}
    user_records.each do |time, users|
      created_time = Time.parse(time)
      record = StatisticRecord.find_or_create_by(kind: 1, record_time: created_time)
      record.update(amount: users.count)
    end
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
      '客服人员'
    elsif self.donations.present?
      '爱心人士'
    end
  end

  def secure_name
    return '' if self.name.blank?
    if self.name.length < 2
      self.name
    else
      self.name.sub(self.name[1, 1], '*')
    end
  end

  # 扣用户余额
  def deduct_balance(amount)
    self.balance -= amount
    self.save
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :nickname, :name, :balance, :donate_amount, :role_tag, :team_id, :phone)
      # json.logi_name self.login
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
      json.merge! summary_builder
      json.avatar self.user_avatar
      json.name self.name
      json.salutation [self.salutation]
      json.gender self.gender == 'male' ? ['男'] : ['女']
      json.use_nickname [self.use_nickname]
      json.email self.email
      json.location [self.province, self.city, self.district]
      json.address self.address
      json.phone self.phone
      json.has_team self.team.present?
      json.team_id self.team_id
      json.team_name self.team.try(:name)
      json.avatar_image do
        json.id self.try(:avatar).try(:id)
        json.url self.try(:user_avatar)
        json.protect_token ''
      end
      json.show_name self.show_name
    end.attributes!
  end

  def offline_donor_summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :phone, :name, :nickname, :state)
      json.show_name self.show_name
    end.attributes!
  end

  def school_user_summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :phone, :name, :nickname)
      json.school_name self.try(:teacher).try(:school).try(:name)
      json.kind self.try(:teacher).kind == 'headmaster' ? '学校负责人' : '教师'
      json.show_name self.show_name
      json.user_avatar do
        json.id self.try(:avatar).try(:id)
        json.url self.try(:user_avatar)
        json.protect_token ''
      end
      json.avatar_src self.user_avatar
    end.attributes!
  end

  def remove_teacher_role(operator)
    self.remove_role(:teacher) if self.has_role?(:teacher)
    self.remove_role(:headmaster) if self.has_role?(:headmaster)
    self.save!
    Notification.create(
        kind: 'remove_teacher_role',
        owner: self,
        user_id: self.id,
        title: '教师角色移除通知',
        content: "#{operator.name}将您的#{self.school}老师角色移除"
    )
    return true, '操作成功'
  end

  # 后台手动合并用户
  def self.admin_combine_user(old_user, new_user)
    return false unless new_user.present?
    self.transaction do
        #所有业务表改为手机用户
        School.where(creater_id: old_user.id).each do |school|
          school.update!(creater_id: new_user.id)
        end
        School.where(user_id: old_user.id).each do |school|
          school.update!(user_id: new_user.id)
        end
        Teacher.where(user_id: old_user.id).each do |teacher|
          teacher.update!(user_id: new_user.id)
        end
        Volunteer.where(user_id: old_user.id).each do |volunteer|
          volunteer.update!(user_id: new_user.id)
        end
        CountyUser.where(user_id: old_user.id).each do |county_user|
          county_user.update!(user_id: new_user.id)
        end
        Team.where(creater_id: old_user.id).each do |team|
          team.update!(creater_id: new_user.id)
        end
        Team.where(manage_id: old_user.id).each do |team|
          team.update!(manage_id: new_user.id)
        end
        new_user.update!(team_id: old_user.team_id)
        #角色绑定
        old_user.roles.each do |role|
          new_user.add_role(role)
        end
        new_user.save!
        #数据迁移： 捐款记录等
        new_user.migrate_donate_record(old_user)
        # 合并账号openid、手机和wechat_profile
        new_user.update!(openid: old_user.openid, profile: old_user.profile, auth_token: old_user.auth_token)
        old_user.generate_auth_token
        old_user.openid = nil
        old_user.login = nil
        old_user.save!
        # 通知
        owner = old_user
        title = '#账户合并# 账户已合并'
        content = "您的账户已与其他账户合并，相关数据已迁移"
        notice = Notification.create!(owner: owner, user_id: old_user.id, title: title, content: content, kind: 'combine_user')
        #旧用户禁用

        old_user.disable!
        new_user.enable!
      end
  end

  # 微信绑定手机号之后，根据手机号合并user记录，绑定volunteer,teacher(headmaster),county_user角色（gsh_child有单独绑定途径）
  # 合并账号
  def self.combine_user(phone, wechat_user)
    return unless phone.present?
    phone_user= User.find_by(phone: phone)
    return unless phone_user.present?
    self.transaction do
        #所有业务表改为手机用户
        School.where(creater_id: wechat_user.id).each do |school|
          school.update!(creater_id: phone_user.id)
        end
        School.where(user_id: wechat_user.id).each do |school|
          school.update!(user_id: phone_user.id)
        end
        Teacher.where(user_id: wechat_user.id).each do |teacher|
          teacher.update!(user_id: phone_user.id)
        end
        Volunteer.where(user_id: wechat_user.id).each do |volunteer|
          volunteer.update!(user_id: phone_user.id)
        end
        CountyUser.where(user_id: wechat_user.id).each do |county_user|
          county_user.update!(user_id: phone_user.id)
        end
        Team.where(creater_id: wechat_user.id).each do |team|
          team.update!(creater_id: phone_user.id)
        end
        Team.where(manage_id: wechat_user.id).each do |team|
          team.update!(manage_id: phone_user.id)
        end
        phone_user.update!(team_id: wechat_user.team_id)
        #角色绑定
        wechat_user.roles.each do |role|
          phone_user.add_role(role)
        end
        phone_user.save!
        #数据迁移： 捐款记录等
        phone_user.migrate_donate_record(wechat_user)
        # 合并账号openid、手机和wechat_profile
        phone_user.update!(openid: wechat_user.openid, profile: wechat_user.profile, auth_token: wechat_user.auth_token)
        wechat_user.generate_auth_token
        wechat_user.openid = nil
        wechat_user.login = nil
        wechat_user.save!
        # 通知
        owner = wechat_user
        title = '#账户合并# 账户已合并'
        content = "您的账户已与其他账户合并，相关数据已迁移"
        notice = Notification.create!(owner: owner, user_id: wechat_user.id, title: title, content: content, kind: 'combine_user')
        #旧用户禁用

        wechat_user.disable!
        phone_user.enable!
      end
  end

  # 迁移捐款记录；用户注册绑定手机号和注册
  def migrate_donate_record(old_user)
    self.transaction do
      DonateRecord.where(donor_id: old_user.id).each do |record|
        record.update!(donor_id: self.id, agent_id: self.id)
      end
      Donation.where(donor_id: old_user.id).each do |donation|
        donation.update!(donor_id: self.id, agent_id: self.id)
      end
      IncomeRecord.where(donor_id: old_user.id).each do |record|
        record.update!(donor_id: self.id, agent_id: self.id)
      end
      AccountRecord.where(donor_id: old_user.id).each do |record|
        record.update!(donor_id: self.id)
      end
      #重算两个账号的缓存数据
      offline_income_resource = IncomeSource.offline
      if IncomeRecord.where(agent_id: self.id).sum(:amount) != self.donate_amount
        self.update!(donate_amount: IncomeRecord.where(agent_id: self.id).sum(:amount))
      elsif IncomeRecord.where(agent_id: self.id, income_source_id: offline_income_resource.ids).sum(:amount) != self.offline_amount
        self.update!(offline_amount: IncomeRecord.where(agent_id: self.id, income_source_id: offline_income_resource.ids).sum(:amount))
      elsif IncomeRecord.where(agent_id: self.id).where.not(income_source_id: offline_income_resource.ids).sum(:amount) != self.online_amount
        self.update!(online_amount: IncomeRecord.where(agent_id: self.id).where.not(income_source_id: offline_income_resource.ids).sum(:amount))
        # elsif AccountRecord.where(user_id: self.id).sum(:amount) != self.balance
        #   sum = AccountRecord.where(user_id: self.id).sum(:amount).to_f
        #   self.update!(balance: sum)
      end
    end
  end

  # 代捐人激活
  def offline_user_activation(phone, wechat_user)
    return unless self.unactived? && self.manager_id.present?
    self.transaction do
      if wechat_user.present?
        User.combine_user(phone, wechat_user)
      else
        self.migrate_donate_record(self)
        self.enable!
      end
      #通知代理人
      owner = self
      title = '#账户已激活# 捐助人已激活账户'
      content = "您的捐助人#{self.show_name}账户已激活，您将不能管理该账户"
      notice = Notification.create!(owner: owner, user_id: self.manager_id, title: title, content: content)
      #将代捐人状态改为已注册，在代捐人列表中显示但不可用
    end
  end

  #设置线下用户管理人
  def set_offline_user_manager(manager, old_manager)
    return unless self.unactived?
    self.transaction do
      self.update!(manager_id: manager.id)
      DonateRecord.where(donor_id: self.id).each do |record|
        record.update!(agent_id: manager.id)
      end
      Donation.where(donor_id: self.id).each do |donation|
        donation.update!(agent_id: manager.id)
      end
      IncomeRecord.where(donor_id: self.id).each do |record|
        record.update!(agent_id: manager.id)
      end


      #重算的缓存数据
      if old_manager.present?
        offline_income_resource = IncomeSource.offline
        if IncomeRecord.where(agent_id: old_manager.id).sum(:amount) != old_manager.donate_amount
          old_manager.update!(donate_amount: IncomeRecord.where(agent_id: old_manager.id).sum(:amount))
        elsif IncomeRecord.where(agent_id: old_manager.id, income_source_id: offline_income_resource.ids).sum(:amount) != old_manager.offline_amount
          old_manager.update!(offline_amount: IncomeRecord.where(agent_id: old_manager.id, income_source_id: offline_income_resource.ids).sum(:amount))
        elsif IncomeRecord.where(agent_id: old_manager.id).where.not(income_source_id: offline_income_resource.ids).sum(:amount) != old_manager.online_amount
          old_manager.update!(online_amount: IncomeRecord.where(agent_id: old_manager.id).where.not(income_source_id: offline_income_resource.ids).sum(:amount))
        end
      end

      offline_income_resource = IncomeSource.offline
      if IncomeRecord.where(agent_id: manager.id).sum(:amount) != manager.donate_amount
        manager.update!(donate_amount: IncomeRecord.where(agent_id: manager.id).sum(:amount))
      elsif IncomeRecord.where(agent_id: manager.id, income_source_id: offline_income_resource.ids).sum(:amount) != manager.offline_amount
        manager.update!(offline_amount: IncomeRecord.where(agent_id: manager.id, income_source_id: offline_income_resource.ids).sum(:amount))
      elsif IncomeRecord.where(agent_id: manager.id).where.not(income_source_id: offline_income_resource.ids).sum(:amount) != manager.online_amount
        manager.update!(online_amount: IncomeRecord.where(agent_id: manager.id).where.not(income_source_id: offline_income_resource.ids).sum(:amount))
      end
    end
  end

  def bind_user_roles
    volunteer = Volunteer.find_by(phone: self.phone)
    teacher = Teacher.find_by(phone: self.phone)
    county_user = CountyUser.find_by(phone: self.phone)
    school = School.find_by(contact_phone: self.phone)
    self.bind_user_with_volunteer(volunteer) if volunteer.present?
    self.bind_user_with_teacher(teacher) if teacher.present?
    self.bind_user_with_headmaster(school) if school.present?
    self.bind_user_with_county_user(county_user) if county_user.present?
  end

  def bind_user_with_volunteer(volunteer)
    self.add_role(:volunteer)
    volunteer.user = self
    volunteer.save
    self.save
  end

  # 绑定老师
  def bind_user_with_teacher(teacher)
    return unless teacher.teacher?
    self.add_role(:teacher)
    teacher.user = self
    teacher.save
    self.save
  end

  def bind_user_with_headmaster(school)
    self.add_role(:headmaster)
    school.user = self
    school.save
    self.save

    # 创建和绑定教师角色
    teacher = Teacher.find_or_create_by(kind: 'headmaster', phone: self.phone, school: school)
    teacher.update(name: self.name)
  end

  def bind_user_with_county_user(county_user)
    self.add_role(:county_user)
    county_user.user = self
    county_user.save
    self.save
  end

end
