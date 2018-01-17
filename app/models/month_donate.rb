# == Schema Information
#
# Table name: month_donates # 月捐表
#
#  id             :integer          not null, primary key
#  user_id        :integer                                # 用户id
#  fund_id        :integer                                # 基金id
#  plan_period    :integer                                # 计划期数
#  donated_period :integer                                # 已捐期数
#  amount         :decimal(14, 2)   default(0.0)          # 每期捐助金额
#  start_time     :datetime                               # 开始时间
#  state          :integer                                # 捐助状态 1:捐助中 2:已结束
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class MonthDonate < ApplicationRecord
  belongs_to :user
  belongs_to :fund

  validates :plan_period, :amount, presence: true

  enum state: {donation: 1, finished: 2} #状态 1:捐助中 2:已结束
  default_value_for :state, 1

  scope :sorted, ->{ order(created_at: :desc) }

end
