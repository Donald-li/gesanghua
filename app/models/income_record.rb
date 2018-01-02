# == Schema Information
#
# Table name: income_records # 入帐记录表
#
#  id               :integer          not null, primary key
#  user_id          :integer                                # 用户id
#  fund_id          :integer                                # 基金ID
#  appoint_type     :string                                 # 指定类型
#  appoint_id       :integer                                # 指定类型id
#  state            :integer                                # 状态
#  income_source_id :integer                                # 来源id
#  amount           :decimal(14, 2)   default(0.0)          # 入账金额
#  balance          :decimal(14, 2)   default(0.0)          # 余额
#  remitter_name    :string                                 # 汇款人姓名
#  remitter_id      :integer                                # 汇款人id
#  donor            :string                                 # 捐赠者
#  promoter_id      :integer                                # 劝捐人
#  donate_record_id :integer                                # 捐助记录id
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class IncomeRecord < ApplicationRecord
  belongs_to :user
  belongs_to :finance_category
  belongs_to :income_source
  belongs_to :promoter, class_name: 'User'
  # belongs_to :remitter, class_name: 'User'

  has_many :expenditure_records
  has_one :donate_record
  # appoint_type 多态关联
  # belongs_to :user, polymorphic: true

  validates :amount, :remitter_name, :donor, presence: true

  # enum state: {}

  scope :sorted, ->{ order(created_at: :desc) }

end
