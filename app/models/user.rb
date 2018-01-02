# == Schema Information
#
# Table name: users # 用户
#
#  id              :integer          not null, primary key
#  openid          :string                                 # 微信openid
#  name            :string                                 # 姓名
#  login           :string                                 # 登录账号
#  password_digest :string                                 # 密码
#  state           :integer          default("enabled")    # 状态 1:启用 2:禁用
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
#

class User < ApplicationRecord

  attr_accessor :avatar_id

  include HasAsset
  has_one_asset :avatar, class_name: 'Asset::UserAvatar'

  belongs_to :team, optional: true

  has_one :administrator
  has_one :teacher
  has_one :volunteer
  has_one :county_user
  has_many :vouchers
  has_many :campaign_enlists
  has_many :donate_records
  has_many :income_records
  has_many :project_applies

  validates :name, :login, presence: true
  validates :login, uniqueness: true
  default_value_for :profile, {}

  enum state: {enabled: 1, disabled: 2} #状态 1:启用 2:禁用
  default_value_for :state, 1

  scope :sorted, ->{ order(created_at: :desc) }

  has_secure_password

  # 用于判断是否验证预留手机号码
  def validate_phone?
    #TODO
  end

  # 可开票金额
  def to_bill_amount
    self.donate_records.where({ created_at: (Time.now.beginning_of_year)..(Time.now.end_of_year), voucher_state: 1 }).sum(:amount)
  end

end
