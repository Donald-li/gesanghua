# == Schema Information
#
# Table name: donate_records # 捐赠记录
#
#  id               :integer          not null, primary key
#  user_id          :integer                                # 用户id
#  appoint_type     :string                                 # 指定类型
#  appoint_id       :integer                                # 指定类型
#  fund_id          :integer                                # 基金ID
#  pay_state        :integer                                # 付款状态
#  amount           :decimal(14, 2)   default(0.0)          # 捐助金额
#  project_id       :integer                                # 项目id
#  project_apply_id :integer                                # 项目申请id
#  team_id          :integer                                # 小组id
#  message          :string                                 # 留言
#  donor            :string                                 # 捐赠者
#  promoter_id      :integer                                # 劝捐人
#  remitter_name    :string                                 # 汇款人姓名
#  remitter_id      :integer                                # 汇款人id
#  voucher_state    :integer                                # 捐赠收据状态
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class DonateRecord < ApplicationRecord
  belongs_to :user
  belongs_to :promoter, class_name: 'User'
  # belongs_to :remitter, class_name: 'User'
  belongs_to :finance_category
  belongs_to :project
  belongs_to :project_apply
  belongs_to :team
  belongs_to :income_record

  has_many :voucher_donate_records
  has_many :vouchers, through: :voucher_donate_records
  # appoint_type 多态关联
  # belongs_to :user, polymorphic: true

  validates :amount, :donor, :remitter_name, presence: true

  enum pay_state: { unpay: 1, paid: 2 } #付款状态， 1:已付款  2:未付款
  default_value_for :pay_state, 1

  enum voucher_state: {to_bill: 1, billed: 2 } #收据状态，1:未开票 2:已开票
  default_value_for :voucher_state, 1

  scope :sorted, ->{ order(created_at: :desc) }

end
