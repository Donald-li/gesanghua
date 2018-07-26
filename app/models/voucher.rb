# == Schema Information
#
# Table name: vouchers # 捐助收据表
#
#  id            :bigint(8)        not null, primary key
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

# 捐赠收据
require 'custom_validators'
class Voucher < ApplicationRecord
  belongs_to :user
  has_one :logistic, as: :owner
  accepts_nested_attributes_for :logistic, reject_if: :all_blank
  has_many :income_records, dependent: :nullify
  validates :contact_name, :contact_phone, :province, :city, :district, :address, presence: true
  # validates :contact_phone, mobile: true

  enum state: { pending: 1, deal: 2 } # 审核状态：1:待处理 2:已处理
  default_value_for :state, 1

  enum kind: { individual: 1, company: 2, other: 3 } # 审核状态：1:个人 2:企业 3:其他
  default_value_for :kind, 1

  scope :sorted, ->{ order(id: :desc) }

  before_create :gen_voucher_no

  def full_address
    ChinaCity.get(self.province).to_s + ChinaCity.get(self.city).to_s + ChinaCity.get(self.district).to_s + self.address.to_s
  end

  def save_voucher(user, ids)
    return false if ids.empty?
    self.transaction do
      begin
        records = user.income_records.to_bill.where(id: ids)
        self.amount = records.sum(:amount)
        return false if self.amount < 100
        self.save!
        records = user.income_records.to_bill.where(id: ids)
        records.update_all(voucher_state: :billed, voucher_id: self.id)
        return true
      rescue => e
        raise e
        return false
      end
    end
    return false
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :amount)
      json.kind self.enum_name(:kind)
      json.state self.deal? ? '已开收据' : '待开收据'
      json.time self.created_at.strftime("%Y-%m-%d %H:%M:%S")
      json.send_state self.logistic.present?
      json.logistic_name self.logistic.enum_name(:name) if self.logistic.present?
    end.attributes!
  end

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id, :amount, :tax_company, :contact_name, :contact_phone)
      json.kind self.enum_name(:kind)
      json.state self.pending? ? '已开收据' : '待开收据'
      json.time self.created_at.strftime("%Y-%m-%d %H:%M:%S")
      json.send_state self.logistic.present?
      json.logistic_name self.logistic.enum_name(:name) if self.logistic.present?
      json.logistic_number self.logistic.try(:number)
      json.full_address self.full_address
    end.attributes!
  end

  private
  def gen_voucher_no
    time_string = Time.now.strftime("%y%m%d")
    self.voucher_no ||= Sequence.get_seq(kind: :voucher_no, prefix: time_string, length: 3)
  end

end
