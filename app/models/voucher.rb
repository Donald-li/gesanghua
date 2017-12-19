# == Schema Information
#
# Table name: vouchers # 捐助收据表
#
#  id            :integer          not null, primary key
#  user_id       :integer                                # 用户ID
#  amount        :decimal(14, 2)   default(0.0)          # 金额
#  state         :integer                                # 状态
#  contact_name  :string                                 # 联系人姓名
#  contact_phone :string                                 # 联系人电话
#  province      :string                                 # 省
#  city          :string                                 # 市
#  district      :string                                 # 区/县
#  address       :string                                 # 详细地址
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Voucher < ApplicationRecord
  belongs_to :user
  has_many :voucher_donate_records
  has_many :billed_donate_records, class_name: 'DonateRecord', through: :voucher_donate_records

  validates :contact_name, :contact_phone, :province, :city, :district, :address, presence: true

  scope :sorted, ->{ order(created_at: :desc) }
end
