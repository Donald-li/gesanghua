# == Schema Information
#
# Table name: campaign_enlists # 活动报名表
#
#  id               :integer          not null, primary key
#  campaign_id      :integer                                # 活动ID
#  user_id          :integer                                # 用户ID
#  number           :integer                                # 报名人数
#  remark           :string                                 # 备注
#  total            :decimal(14, 2)   default(0.0)          # 合计报名金额
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  contact_name     :string                                 # 联系人
#  contact_phone    :string                                 # 联系电话
#  payment_state    :integer          default("paid")       # 支付状态 1:已支付 2:已取消
#  income_source_id :integer                                # 收入来源id
#  form             :jsonb                                  # 报名表单
#

# 活动报名
require 'custom_validators'
class CampaignEnlist < ApplicationRecord

  belongs_to :campaign
  belongs_to :user

  belongs_to :income_source, optional: true

  validates :number, presence: true

  validates :contact_phone, phone: true

  #default_vaule_for :number, 1

  enum payment_state: {unpaid: 0, paid: 1, canceled: 2} #支付状态 1:已支付 2:已取消
  default_value_for :payment_state do |enlist|
    if enlist.campaign.try(:price).to_f <= 0
      1
    else
      0
    end
  end
  default_value_for :number, 1
  default_value_for :form, {}

  scope :sorted, ->{ order(created_at: :desc) }

  # 使用捐助
  def accept_donate(donate_records)
    donate_record = donate_records.last
    amount = donate_record.amount
    donate_record.update!(amount: amount)

    self.payment_state = 'paid'
    self.save!
  end

  def total_price
    self.number.to_i * self.campaign.price.to_f
  end

  # 动态表单内容的builder
  def form_builder
    campaign = self.campaign
    Jbuilder.new do |json|
      json.array!(campaign.form) do |item|
        json.label item['label']
        json.key item['key']
        json.value self.form[item['key']] || ''
      end
    end.attributes!
  end
end
