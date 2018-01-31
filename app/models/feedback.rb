# == Schema Information
#
# Table name: feedbacks # 反馈表
#
#  id            :integer          not null, primary key
#  content       :text                                   # 内容
#  owner_type    :string
#  owner_id      :integer
#  type          :integer                                # 类型：receive、install、continual
#  state         :integer                                # 状态
#  approve_state :integer                                # 审核状态
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  kind          :integer                                # 反馈类型
#  check         :integer                                # 查看 1: 未查看 2: 已查看
#  recommend     :integer                                # 推荐 1: 正常 2: 推荐
#  user_id       :integer                                # 反馈人
#

class Feedback < ApplicationRecord
  belongs_to :owner, polymorphic: true
  belongs_to :user

  validates :content, presence: true

  enum kind: {default: 0, grant: 1, continue: 2}
  default_value_for :kind, 0

  enum state: {show: 1, hidden: 2}
  default_value_for :state, 1

  enum check: {uncheck: 1, checked: 2}# 查看 1: 未查看 2: 已查看
  default_value_for :check, 1

  enum recommend: {normal: 1, recommend: 2}# 推荐 1: 正常 2: 推荐
  default_value_for :recommend, 1

  enum approve_state: {submit: 1, pass: 2, reject: 3} # 审核状态 1:审核中 2:申请通过 3:申请不通过
  default_value_for :approve_state, 1

  scope :sorted, ->{ order(created_at: :desc) }

end
