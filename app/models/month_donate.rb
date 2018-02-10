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
#  project_id     :integer                                # 项目ID
#  certificate_no :string                                 # 捐赠证书编号
#

class MonthDonate < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :user
  belongs_to :fund
  belongs_to :project, optional: true

  has_many :donate_records, dependent: :destroy

  validates :plan_period, :donated_period, :amount, :start_time, presence: true

  enum state: {donation: 1, finished: 2} #状态 1:捐助中 2:已结束
  default_value_for :state, 1

  default_value_for :plan_period, 0
  default_value_for :donated_period, 0

  scope :sorted, ->{ order(created_at: :desc) }

  def pay_and_gen_certificate
    self.certificate_no ||= 'ZS' + self.donate_no
    self.pay_state = 'paid'
    self.save
  end

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

  def certificate_builder
    Jbuilder.new do |json|
      json.(self, :id)
      json.donate_item_name self.donate_item.try(:name)
      json.amount number_to_currency(self.amount)
      json.user_name self.user.present? ? self.user.name : '爱心人士'
      json.time_name "#{self.created_at.year}年#{self.created_at.month}月#{self.created_at.day}日"
      json.certificate_no self.certificate_no
      json.project self.try(:project).try(:name)
    end.attributes!
  end


end
