# == Schema Information
#
# Table name: users # 用户
#
#  id              :integer          not null, primary key
#  openid          :string                                 # 微信openid
#  name            :string                                 # 姓名
#  login           :string                                 # 登录账号
#  password_digest :string                                 # 密码
#  state           :integer          default(1)            # 状态 1:启用 2:禁用
#  team_id         :integer                                # 团队ID
#  profile         :jsonb                                  # 微信profile
#  gender          :integer                                # 性别，1：男 2：女
#  balance         :decimal(14, 2)   default(0.0)          # 账户余额
#  phone           :string                                 # 联系方式
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  has_many :vouchers
  belongs_to :team
  has_one :teacher
  has_one :volunteer

  validates :login, presence: true, uniqueness: true
  validates :password_digest, presence: true, confirmation: true
  validates :state, numericality: {only_integer: true}
  validates :team_id, numericality: {only_integer: true}
  validates :gender, numericality: {only_integer: true}
  validates :balance, numericality: true
end
