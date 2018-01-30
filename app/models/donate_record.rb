# == Schema Information
#
# Table name: donate_records # 捐赠记录
#
#  id                            :integer          not null, primary key
#  user_id                       :integer                                # 用户id
#  appoint_type                  :string                                 # 指定类型
#  appoint_id                    :integer                                # 指定类型
#  fund_id                       :integer                                # 基金ID
#  pay_state                     :integer                                # 付款状态
#  amount                        :decimal(14, 2)   default(0.0)          # 捐助金额
#  project_id                    :integer                                # 项目id
#  team_id                       :integer                                # 小组id
#  message                       :string                                 # 留言
#  donor                         :string                                 # 捐赠者
#  promoter_id                   :integer                                # 劝捐人
#  remitter_name                 :string                                 # 汇款人姓名
#  remitter_id                   :integer                                # 汇款人id
#  voucher_state                 :integer                                # 捐赠收据状态
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  project_season_id             :integer                                # 年度ID
#  project_season_apply_id       :integer                                # 年度项目ID
#  project_season_apply_child_id :integer                                # 年度孩子申请ID
#  donate_no                     :string                                 # 捐赠编号
#  voucher_id                    :integer                                # 捐助记录ID
#  period                        :integer                                # 月捐期数
#  month_donate_id               :integer                                # 月捐id
#  certificate_no                :string                                 # 捐赠证书编号
#  kind                          :integer                                # 记录类型: 1:系统生成 2:手动添加
#  gsh_child_id                  :integer                                # 格桑花孩子id
#

class DonateRecord < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :user
  belongs_to :promoter, class_name: 'User', foreign_key: 'promoter_id', optional: true
  belongs_to :project, optional: true
  belongs_to :season, class_name: 'ProjectSeason', foreign_key: 'project_season_id', optional: true
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: 'project_season_apply_id', optional: true
  belongs_to :child, class_name: 'ProjectSeasonApplyChild', foreign_key: 'project_season_apply_child_id', optional: true
  belongs_to :team, optional: true
  belongs_to :project_season_apply_child, optional: true # TODO: 检查下，没用删掉
  has_one :income_record, dependent: :destroy
  belongs_to :voucher, optional: true
  belongs_to :month_donate, optional: true
  belongs_to :fund, optional: true
  belongs_to :appoint, polymorphic: true, optional: true
  belongs_to :gsh_child, optional: true

  counter_culture :project, column_name: :donate_record_amount_count, delta_magnitude: proc {|model| model.amount}

  validates :amount, presence: true

  enum pay_state: { unpay: 1, paid: 2 } #付款状态， 1:已付款  2:未付款
  default_value_for :pay_state, 1

  enum kind: {system: 1, custom: 2} # 记录类型: 1:系统生成 2:手动添加
  default_value_for :kind, 1

  enum voucher_state: {to_bill: 1, billed: 2 } #收据状态，1:未开票 2:已开票
  default_value_for :voucher_state, 1

  scope :sorted, ->{ order(created_at: :desc) }

  scope :donate_gsh_child, ->{ where("gsh_child_id IS NOT NULL")} # 捐助给孩子的记录

  before_create :gen_donate_no

  def pay_and_gen_certificate
    self.certificate_no ||= 'ZS' + self.donate_no
    self.pay_state = 'paid'
    self.save
  end

  def self.donate_gsh(user: nil, amount: 0.0, promoter: nil)
    self.create(user: user, amount: amount ,team: nil, fund: Fund.gsh, pay_state: 'unpay', promoter: promoter, remitter_name: promoter.try(:name), apply: nil, child: nil, project: nil)
  end

  # 定项非指定
  def self.donate_project(user: nil, amount: 0.0, promoter: nil, project: nil)
    return unless project.present?
    self.create(user: user, amount: amount ,team: nil, fund: project.fund, pay_state: 'unpay', promoter: promoter, remitter_name: promoter.try(:name), apply: nil, child: nil, project: project)
  end

  # 计算开票金额
  def self.count_amount(ids)
    donates = DonateRecord.find(ids)
    if donates.present?
      amount = donates.sum{|d| d.amount.to_f}
      return amount
    else
      return 0
    end
  end

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id)
      json.user_name self.user.present? ? self.user.name : '爱心人士'
      json.time self.created_at.strftime('%Y-%m-%d %H:%M:%S')
      json.amount number_to_currency(self.amount)
      json.item_name self.appoint.present? ? self.appoint.name : ''
      json.team self.team.present? ? self.team.name : ''
      json.project self.try(:project).try(:name)
    end.attributes!
  end

  private
  def gen_donate_no
    time_string = Time.now.strftime("%y%m%d%H")
    self.donate_no ||= Sequence.get_seq(kind: :donate_no, prefix: time_string, length: 7)
  end

end
