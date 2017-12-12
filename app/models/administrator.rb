# == Schema Information
#
# Table name: administrators # 管理员
#
#  id              :integer          not null, primary key
#  login           :string                                                         # 登录名
#  nickname        :string                                                         # 昵称
#  password_digest :string                                                         # 密码
#  expire_at       :datetime         default(Thu, 31 Dec 2099 00:00:00 UTC +00:00) # 过期时间
#  state           :integer          default("enable")                             # 状态 1:正常 2:禁用
#  kind            :integer          default("administrator")                      # 管理员类型 1:超级管理员 2:普通管理员
#  integer         :integer          default(2)                                    # 管理员类型 1:超级管理员 2:普通管理员
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Administrator < ApplicationRecord
  has_paper_trail only: [:login, :nickname, :state]

  has_secure_password
  enum state: { enable: 1, disable: 2 } # 状态 1:正常 2:禁用
  default_value_for :state, 1

  enum kind: { super_administrator: 1, administrator: 2} # 管理员类型 1:超级管理员 2:系统管理员
  default_value_for :kind, 2

  scope :sorted, -> { order(created_at: :desc) }

  validates :login, presence: true, uniqueness: true
  validates :nickname, presence: true
  validates :password, length: { in: 6..32 }, if: :need_validate_password?

  has_many :administrator_logs, dependent: :destroy

  protected
  def need_validate_password?
    self.password_digest.blank? || self.password.present?
  end
end
