# == Schema Information
#
# Table name: month_donates # 月捐表
#
#  id             :bigint(8)        not null, primary key
#  user_id        :integer                                # 用户id
#  fund_id        :integer                                # 基金id
#  plan_period    :integer                                # 计划期数
#  donated_period :integer                                # 已捐期数
#  amount         :decimal(14, 2)   default(0.0)          # 每期捐助金额
#  start_time     :datetime                               # 开始时间
#  state          :integer                                # 捐助状态 1:捐助中 2:已结束
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  project_id     :integer                                # 项目ID
#  certificate_no :string                                 # 捐赠证书编号
#

# 月捐
class MonthDonate < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :user
  belongs_to :fund
  belongs_to :project, optional: true

  has_many :donate_records, dependent: :nullify

  validates :plan_period, :donated_period, :amount, :start_time, presence: true

  enum state: {donation: 1, finished: 2} #状态 1:捐助中 2:已结束
  default_value_for :state, 1

  default_value_for :plan_period, 0
  default_value_for :donated_period, 0

  scope :sorted, ->{ order(created_at: :desc) }

  def self.month_donate_gsh(user = nil, amount = 0.0, plan_period = 0)
    return false unless user.present?
    gsh_fund = Fund.gsh
    donate = user.month_donates.build(amount: amount, fund: gsh_fund, plan_period: plan_period, start_time: Time.now)
    donate.save
    return donate
  end

  def self.month_donate_project(user = nil, amount = 0.0, project = nil, plan_period = 0)
    return false unless user.present?
    return false unless project.present?
    fund = project.fund
    donate = user.month_donates.build(amount: amount, fund: fund, project: project, plan_period: plan_period, start_time: Time.now)
    donate.save
    return donate
  end

  def self.month_donate_donate_item(user = nil, amount = 0.0, donate_item = nil, plan_period = 0)
    return false unless user.present?
    return false unless donate_item.present?
    fund = donate_item.fund
    donate = user.month_donates.build(amount: amount, fund: fund, donate_item: donate_item, plan_period: plan_period, start_time: Time.now)
    donate.save
    return donate
  end

end
