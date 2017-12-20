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
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  belongs_to :team

  has_one :teacher
  has_one :volunteer
  has_one :education_bureau_employee
  has_many :vouchers
  has_many :campaign_enlists
  has_many :donate_records
  has_many :income_records
  has_many :project_applies

  validates :name, :login, :phone, presence: true
  validates :login, :phone, uniqueness: true
  default_value_for :profile, {}

  enum state: {enabled: 1, disabled: 2} #状态 1:启用 2:禁用
  default_value_for :state, 1

  scope :sorted, ->{ order(created_at: :desc) }

  has_secure_password

end
