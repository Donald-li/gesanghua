# == Schema Information
#
# Table name: administrators # 管理员
#
#  id         :integer          not null, primary key
#  nickname   :string                                                         # 昵称
#  expire_at  :datetime         default(Thu, 31 Dec 2099 00:00:00 CST +08:00) # 过期时间
#  state      :integer          default("enable")                             # 状态 1:正常 2:禁用
#  user_id    :integer
#  kind       :integer          default("system_administrator")               # 管理员类型 1:超级管理员 2:系统管理员 3:项目管理员 4:财务人员
#  integer    :integer          default(2)                                    # 管理员类型 1:超级管理员 2:系统管理员 3:项目管理员 4:财务人员
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Administrator < ApplicationRecord

  belongs_to :user

  has_many :administrator_logs, dependent: :destroy
  has_many :expenditure_records

  validates :nickname, presence: true

  enum state: { enable: 1, disable: 2 } # 状态 1:正常 2:禁用
  default_value_for :state, 1

  enum kind: { super_administrator: 1, system_administrator: 2, project_administrator: 3, financial_staff: 4, operator: 5} # 管理员类型 1:超级管理员 2:系统管理员 3:项目管理员 4:财务人员 5:运营人员
  default_value_for :kind, 2

  scope :sorted, -> { order(created_at: :asc) }

end
