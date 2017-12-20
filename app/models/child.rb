# == Schema Information
#
# Table name: children # 格桑花孩子表
#
#  id              :integer          not null, primary key
#  idcard          :string                                 # 身份证
#  name            :string                                 # 姓名
#  school_id       :integer                                # 学校ID
#  user_id         :integer                                # 用户ID
#  password_digest :string                                 # 密码
#  gsh_no          :string                                 # 格桑花内部编码
#  state           :integer          default("enabled")    # 状态：1:启用 2:禁用
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Child < ApplicationRecord
  has_many :child_trails
  has_many :child_grants
  has_many :project_apply_children
  has_many :visit_children
  has_many :visits, through: :visit_children

  validates :idcard, :name, :gsh_no, presence: true
  validates :idcard, uniqueness: true

  enum state: {enabled: 1, disabled: 2} # 状态：1:启用 2:禁用
  default_value_for :state, 1

  scope :sorted, ->{ order(created_at: :desc) }

end
