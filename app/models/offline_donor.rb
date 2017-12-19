# == Schema Information
#
# Table name: offline_donors # 代捐人表
#
#  id         :integer          not null, primary key
#  user_id    :integer                                # 用户ID
#  name       :string                                 # 姓名
#  state      :integer                                # 状态
#  gender     :integer                                # 性别，1：男 2：女
#  email      :string                                 # 邮箱
#  phone      :string                                 # 联系方式
#  address    :string                                 # 详细地址
#  province   :string                                 # 省
#  city       :string                                 # 市
#  district   :string                                 # 区
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class OfflineDonor < ApplicationRecord
  belongs_to :user

  validates :name, :province, :city, :district, presence: true
  validates :phone, uniqueness: true

  # enum state: {enabled: 1, disabled: 2} # 状态 1:启用 2:停用

  scope :sorted, ->{ order(created_at: :desc) }
end
