# == Schema Information
#
# Table name: administrator_logs # 管理员日志
#
#  id               :integer          not null, primary key
#  administrator_id :integer                                # 管理员id
#  kind             :integer                                # 日志动作类型，1:登录 2:登出
#  ip               :string                                 # ip地址
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

# 管理员登录日志
class AdministratorLog < ApplicationRecord
  belongs_to :administrator, class_name: 'User', foreign_key: 'administrator_id'

  scope :sorted, -> { order(created_at: :desc) }
end
