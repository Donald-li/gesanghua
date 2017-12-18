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
#  state           :integer          default("show")       # 状态：1:启用 2:禁用
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Child < ApplicationRecord

  enum state: {show: 1, hidden: 2} # 状态：1:启用 2:禁用

  validates :idcard, :name, :gsh_no, presence: true

  has_many :visit_children
  has_many :visits, through: :visit_children

  validates school_id, numericality: {only_integer: true}
  validates user_id, numericality: {only_integer: true}
  validates :password_digest, confirmation: true
  validates :state, numericality: {only_integer: true}
end
