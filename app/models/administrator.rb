class Administrator < ApplicationRecord
  has_secure_password
  enum state: { enable: 1, disable: 2 } # 状态 1:正常 2:禁用
  default_value_for :state, 1

  validates :login, presence: true, uniqueness: true
  validates :nickname, presence: true
  validates :password, length: { in: 6..32 }, if: :need_validate_password?

  protected
  def need_validate_password?
    self.password_digest.blank? || self.password.present?
  end
end
