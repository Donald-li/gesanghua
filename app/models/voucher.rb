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
#  kind          :integer                                # 开票类型
#  tax_no        :string                                 # 开票税号
#  voucher_no    :string                                 # 发票编号
#  tax_company   :string                                 # 开票单位
#

class Voucher < ApplicationRecord
  require 'custom_validators'
  belongs_to :user
  has_one :logistic, as: :owner
  accepts_nested_attributes_for :logistic, reject_if: :all_blank
  has_many :donate_records
  validates :contact_name, :contact_phone, :province, :city, :district, :address, presence: true
  validates :contact_phone, mobile: true

  enum state: { pending: 1, deal: 2 } # 审核状态：1:待处理 2:已处理
  default_value_for :state, 1

  enum kind: { individual: 1, company: 2, other: 3 } # 审核状态：1:个人 2:企业 3:其他
  default_value_for :kind, 1

  scope :sorted, ->{ order(created_at: :desc) }

  def full_address
    ChinaCity.get(self.province).to_s + ChinaCity.get(self.city).to_s + ChinaCity.get(self.district).to_s + self.address.to_s
  end

  def save_voucher(ids)
    self.transaction do
      begin
        self.save!
        records = ids.map{ |i| DonateRecord.find_by_id(i) }.compact
        voucher_id = self.id
        records.each{ |e| e.update!( voucher_state: 2, voucher_id: voucher_id ) }
        return true
      rescue
        return false
      end
    end
    return false
  end

end
