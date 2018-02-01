# == Schema Information
#
# Table name: donate_records # 捐赠记录
#
#  id                                :integer          not null, primary key
#  user_id                           :integer                                # 用户id
#  appoint_type                      :string                                 # 指定类型
#  appoint_id                        :integer                                # 指定类型
#  fund_id                           :integer                                # 基金ID
#  pay_state                         :integer                                # 付款状态
#  amount                            :decimal(14, 2)   default(0.0)          # 捐助金额
#  project_id                        :integer                                # 项目id
#  team_id                           :integer                                # 小组id
#  message                           :string                                 # 留言
#  donor                             :string                                 # 捐赠者
#  promoter_id                       :integer                                # 劝捐人
#  remitter_name                     :string                                 # 汇款人姓名
#  remitter_id                       :integer                                # 汇款人id
#  voucher_state                     :integer                                # 捐赠收据状态
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  project_season_id                 :integer                                # 年度ID
#  project_season_apply_id           :integer                                # 年度项目ID
#  project_season_apply_child_id     :integer                                # 年度孩子申请ID
#  donate_no                         :string                                 # 捐赠编号
#  voucher_id                        :integer                                # 捐助记录ID
#  period                            :integer                                # 月捐期数
#  month_donate_id                   :integer                                # 月捐id
#  certificate_no                    :string                                 # 捐赠证书编号
#  gsh_child_id                      :integer                                # 格桑花孩子id
#  kind                              :integer                                # 记录类型: 1:系统生成 2:手动添加
#  project_season_apply_bookshelf_id :integer                                # 书架id
#

class DonateRecord < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :user, optional: true
  belongs_to :promoter, class_name: 'User', foreign_key: 'promoter_id', optional: true
  belongs_to :project, optional: true
  belongs_to :season, class_name: 'ProjectSeason', foreign_key: 'project_season_id', optional: true
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: 'project_season_apply_id', optional: true
  belongs_to :child, class_name: 'ProjectSeasonApplyChild', foreign_key: 'project_season_apply_child_id', optional: true
  belongs_to :bookshelf, class_name: 'ProjectSeasonApplyBookshelf', foreign_key: 'project_season_apply_bookshelf_id', optional: true
  belongs_to :team, optional: true
  has_one :income_record, dependent: :destroy
  belongs_to :voucher, optional: true
  belongs_to :month_donate, optional: true
  belongs_to :fund, optional: true
  belongs_to :appoint, polymorphic: true, optional: true
  belongs_to :gsh_child, optional: true

  counter_culture :project, column_name: :donate_record_amount_count, delta_magnitude: proc {|model| model.amount}
  counter_culture :user, column_name: :donate_count, delta_magnitude: proc {|model| model.amount}
  # TODO: 统计用户线上和线下捐助金额

  validates :amount, presence: true

  enum pay_state: {unpay: 1, paid: 2} #付款状态， 1:已付款  2:未付款
  default_value_for :pay_state, 1

  enum kind: {system: 1, custom: 2} # 记录类型: 1:系统生成 2:手动添加
  default_value_for :kind, 1

  enum voucher_state: {to_bill: 1, billed: 2} #收据状态，1:未开票 2:已开票
  default_value_for :voucher_state, 1

  scope :sorted, -> {order(created_at: :desc)}

  scope :donate_gsh_child, -> {where("gsh_child_id IS NOT NULL")} # 捐助给孩子的记录

  scope :platform, -> {where('user_id IS NULL')} # 平台配捐

  scope :user, -> {where('user_id IS NOT NULL')} # 用户捐款

  before_create :gen_donate_no

  def pay_and_gen_certificate
    self.certificate_no ||= 'ZS' + self.donate_no
    self.pay_state = 'paid'
    self.save
  end

  # 捐给格桑花
  def self.donate_gsh(user = nil, amount = 0.0, promoter = nil)
    return false unless user.present?
    gsh_fund = Fund.gsh
    donate = user.donates.build(amount: amount, fund: gsh_fund, promoter: promoter, pay_state: 'unpay')
    donate.save
  end

  # 捐定向
  def self.donate_project(user = nil, amount = 0.0, project = nil, promoter = nil)
    return false unless user.present?
    return false unless project.present?
    fund = project.fund
    donate = user.donates.build(amount: amount, fund: fund, promoter: promoter, pay_state: 'unpay', project: project)
    donate.save
  end

  # 捐孩子
  def self.donate_child(user = nil, gsh_child = nil, semester_num = 0, promoter = nil, kind = 'system')
    # return false unless user.present?
    return false unless gsh_child.present?

    total = self.donate_child_total(gsh_child, semester_num)

    project = Project.pair_project

    donate = self.build(user_id: user.id, amount: total, fund: project.appoint_fund, promoter: promoter, pay_state: 'unpay', project: project, gsh_child: gsh_child, kind: kind)
    if donate.save
      semesters.update(donate_state: :succeed)
    end
  end

  # 捐悦读(整捐)
  def self.donate_bookshelf(user = nil, bookshelf = nil, promoter = nil)
    return false unless user.present?
    return false unless bookshelf.present?
    return false if bookshelf.surplus > 0
    project = Project.book_project
    donate = user.donates.build(amount: bookshelf.amount, promoter: promoter, fund: project.appoint_fund, project: project, bookshelf: bookshelf)
    if donate.save
      bookshelf.surplus = 0
      bookshelf.state = 'complete'
      bookshelf.save
    end
  end

  def self.donate_child_total(gsh_child, semester_num)
    scope = gsh_child.semesters.pending.sorted
    return false if scope.count < semester_num || semester_num < 1

    semesters = scope.limit(semester_num)

    return semesters.to_a.sum {|a| a.amount}
  end

  # 计算开票金额
  def self.count_amount(ids)
    donates = DonateRecord.find(ids)
    if donates.present?
      amount = donates.sum {|d| d.amount.to_f}
      return amount
    else
      return 0
    end
  end

  # 配捐给申请/项目
  def self.platform_donate_apply(params, apply)
    if params[:donate_way] == 'offline'
      user = User.find(params[:offline_user_id])
      donate_record = DonateRecord.new(params.merge(fund: apply.project.fund, pay_state: 'paid', amount: amount, project: apply.project, donor: user.name, remitter_id: user.id, remitter_name: user.name, season: apply.season, apply: apply, kind: 'custom'))
    elsif params[:donate_way] == 'match'
      match_fund = Fund.find(params[:match_fund_id])
      match_fund.amount -= amount.to_f
      return false if match_fund.amount < 0
      donate_record = DonateRecord.new(params.merge(fund: apply.project.fund, pay_state: 'paid', amount: amount, project: apply.project, season: apply.season, apply: apply, kind: 'custom'))
    elsif params[:donate_way] == 'balance'
      user = User.find(params[:balance_id])
      user.balance -= amount
      return false if user.balance < 0
      donate_record = DonateRecord.new(params.merge(fund: apply.project.fund, pay_state: 'paid', amount: amount, project: apply.project, donor: user.name, remitter_id: user.id, remitter_name: user.name, season: apply.season, apply: apply, kind: 'custom'))
    end
    income_record = IncomeRecord.new(donate_record: donate_record, user: donate_record.user, fund: donate_record.fund, amount: amount, remitter_id: donate_record.remitter_id, remitter_name: donate_record.remitter_name, donor: donate_record.donor, promoter_id: donate_record.promoter_id, income_time: Time.now)
    income_record.income_source_id = params[:source_id]
    self.transaction do
      begin
        donate_record.save && income_record.save
        match_fund.save if match_fund.present?
        user.save if user.present?
        return true
      rescue
        return false
      end
    end
    return false
  end

  # 配捐给孩子
  def self.platform_donate_child(params, child)
    user = ''
    semester_num = params[:grant_number]
    amount = self.donate_child_total(child, semester_num)
    if params[:donate_way] == 'offline'
      user = User.find(params[:offline_user_id])
    elsif params[:donate_way] == 'match'
      match_fund = Fund.find(params[:match_fund_id])
      match_fund.amount -= amount.to_f
      return false if match_fund.amount < 0
    elsif params[:donate_way] == 'balance'
      user = User.find(params[:balance_id])
      user.balance -= amount
      return false if user.balance < 0
    end

    donate_record = self.donate_child(user, child, semester_num, nil, 'custom')
    income_record = donate_record.gen_income_record
    income_record.income_source_id = params[:source_id]

    self.transaction do
      begin
        donate_record.save && income_record.save
        match_fund.save if match_fund.present?
        user.save if user.present?
        return true
      rescue
        return false
      end
    end
    return false
  end

  def gen_income_record
    IncomeRecord.new(donate_record: self, user: self.user, fund: self.fund, amount: amount, remitter_id: self.remitter_id, remitter_name: self.remitter_name, donor: self.donor, promoter_id: self.promoter_id, income_time: Time.now)
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
