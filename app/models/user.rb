# == Schema Information
#
# Table name: users # 用户
#
#  id              :integer          not null, primary key
#  openid          :string                                 # 微信openid
#  name            :string                                 # 姓名
#  login           :string                                 # 登录账号
#  password_digest :string                                 # 密码
#  state           :integer          default("enable")     # 状态 1:启用 2:禁用
#  team_id         :integer                                # 团队ID
#  profile         :jsonb                                  # 微信profile
#  gender          :integer                                # 性别，1：男 2：女
#  balance         :decimal(14, 2)   default(0.0)          # 账户余额
#  phone           :string                                 # 联系方式
#  email           :string                                 # 电子邮箱地址
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  nickname        :string                                 # 昵称
#  salutation      :string                                 # 孩子们如何称呼我
#  consignee       :string                                 # 收货人
#  province        :string                                 # 省
#  city            :string                                 # 市
#  district        :string                                 # 区/县
#  address         :string                                 # 详细地址
#  qq              :string                                 # qq号
#  idcard          :string                                 # 身份证
#  donate_count    :decimal(14, 2)   default(0.0)          # 捐助金额
#  online_count    :decimal(14, 2)   default(0.0)          # 线上捐助金额
#  offline_count   :decimal(14, 2)   default(0.0)          # 线下捐助金额
#  auth_token      :string                                 # Token
#

class User < ApplicationRecord

  require 'custom_validators'

  attr_accessor :avatar_id

  include HasAsset
  has_one_asset :avatar, class_name: 'Asset::UserAvatar'

  belongs_to :team, optional: true

  has_one :school
  has_one :administrator
  has_one :teacher
  has_one :volunteer
  has_one :county_user
  has_one :gsh_child
  has_many :vouchers
  has_many :campaign_enlists
  has_many :donate_records
  has_many :income_records
  has_many :project_season_applies
  has_many :month_donates
  has_many :offline_donors

  validates :password, confirmation: true, length: { minimum: 6 }, allow_blank: true
  default_value_for :password, '111111'
  validates :email, email: true
  validates :phone, mobile: true
  validates :name, :login, presence: true
  validates :login, uniqueness: true
  default_value_for :profile, {}

  enum state: {enable: 1, disable: 2} #状态 1:启用 2:禁用
  default_value_for :state, 1

  enum gender: {male: 1, female: 2} #性别 1:男 2:女
  default_value_for :gender, 1

  scope :sorted, ->{ order(created_at: :desc) }
  scope :reverse_sorted, ->{ order(created_at: :asc) }

  before_create :generate_auth_token


  has_secure_password

  def generate_auth_token
    loop do
      self.auth_token = SecureRandom.base64(64)
      break if !User.find_by(auth_token: auth_token)
    end
  end

  def user_avatar
    self.profile["headimgurl"] || self.avatar.file_url(:tiny)
  end

  # 用于判断是否验证预留手机号码
  def validate_phone?
    #TODO
  end

  # 可开票金额
  def to_bill_amount
    self.donate_records.where({ created_at: (Time.now.beginning_of_year)..(Time.now.end_of_year), voucher_state: 1, pay_state: 2 }).sum(:amount)
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

  def has_volunteer?
    self.volunteer.present?
  end

  def self.update_user_statistic_record
    time = Time.now
    amount = self.where("created_at > ? and created_at < ?", time.beginning_of_day, time.end_of_day).count
    record = StatisticRecord.find_or_create_by(amount: amount, kind: 1, record_time: time)
    record.update(amount: amount)
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :nickname)
      json.login_name self.login
      json.avatar self.avatar
    end.attributes!
  end

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id, :nickname)
      json.login_name self.login
      json.avatar self.avatar
    end.attributes!
  end

end
