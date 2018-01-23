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
#  nickname   :string                                 # 昵称
#  salutation :string                                 # 孩子们如何称呼我
#

class OfflineDonor < ApplicationRecord
  belongs_to :user

  validates :name, :province, :city, :district, presence: true
  validates :phone, uniqueness: true

  enum state: {show: 1, hidden: 2} # 是否使用昵称 1:启用 2:停用
  default_value_for :state, 2

  scope :sorted, ->{ order(created_at: :desc) }

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :name, :phone)
    end.attributes!
  end
end
