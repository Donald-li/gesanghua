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
#  bookshelf_supplement_id           :integer                                # 补书ID
#  donate_item_id                    :integer                                # 可捐助id
#  income_record_id                  :integer                                # 收入记录
#  title                             :string                                 # 捐赠标题
#  pay_result                        :string                                 # 支付结果
#

# 捐助记录
class DonateRecord < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :user, optional: true
  belongs_to :promoter, class_name: 'User', foreign_key: 'promoter_id', optional: true
  belongs_to :project, optional: true
  belongs_to :season, class_name: 'ProjectSeason', foreign_key: 'project_season_id', optional: true
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: 'project_season_apply_id', optional: true
  belongs_to :child, class_name: 'ProjectSeasonApplyChild', foreign_key: 'project_season_apply_child_id', optional: true
  belongs_to :bookshelf, class_name: 'ProjectSeasonApplyBookshelf', foreign_key: 'project_season_apply_bookshelf_id', optional: true
  belongs_to :supplement, class_name: 'BookshelfSupplement', foreign_key: 'bookshelf_supplement_id', optional: true
  belongs_to :team, optional: true
  belongs_to :income_record, optional: true
  belongs_to :voucher, optional: true
  belongs_to :month_donate, optional: true
  belongs_to :fund, optional: true
  belongs_to :appoint, polymorphic: true, optional: true
  belongs_to :gsh_child, class_name: 'ProjectSeasonApplyChild', optional: true
  belongs_to :donate_item, optional: true

  counter_culture :project, column_name: :donate_record_amount_count, delta_magnitude: proc {|model| model.amount}
  counter_culture :user, column_name: :donate_count, delta_magnitude: proc {|model| model.amount}
  # TODO: 统计用户线上和线下捐助金额

  validates :amount, presence: true

  enum pay_state: {unpay: 1, paid: 2, refund: 3} #付款状态， 1:未付款 2:已付款 3:已退款
  default_value_for :pay_state, 1

  enum kind: {system: 1, platform: 2} # 记录类型: 1:系统生成 2:配捐
  default_value_for :kind, 1

  enum voucher_state: {to_bill: 1, billed: 2} #收据状态，1:未开票 2:已开票
  default_value_for :voucher_state, 1

  scope :sorted, -> {order(created_at: :desc)}

  scope :donate_gsh_child, -> {where("gsh_child_id IS NOT NULL")} # 捐助给孩子的记录

  scope :user, -> {where('user_id IS NOT NULL')} # 用户捐款

  before_create :gen_donate_no

  # 项目是否可以退款
  def can_refund?
    self.paid? && self.user && self.system?
  end

  # 退款
  def do_refund!
    user = self.user
    return unless user
    self.transaction do
      begin
        User.update_counters(user.id, self.amount)
        self.pay_state = :refund
        self.save!
        return true
      rescue
        return false
      end
    end
  end

  def pay_and_gen_certificate
    self.certificate_no ||= 'ZS' + self.donate_no
    self.pay_state = 'paid'
    self.donor_certificate_path # TODO 调用捐赠证书方法，生成证书（微信支付调通以后，需要考虑此方法的执行速度）
    self.save
  end

  #捐赠证书路径
  def donor_certificate_path
    path = "/images/certificates/#{self.created_at.strftime('%Y%m%d')}/#{self.id}/#{Encryption.md5(self.id.to_s)}.jpg"
    local_path = Rails.root.to_s + '/public' + path
    if !File::exist?(local_path)
      GenDonateCertificate.create(self)
    end
    path
  end

  def project_name
    self.project.try(:name) || '格桑花'
  end

  def donate_item_name
    self.donate_item.try(:name)
  end

  def donor_name
    self.donor || self.user.name
  end

  # 捐给格桑花
  def self.donate_gsh(user = nil, amount = 0.0, promoter = nil)
    return false unless user.present?
    gsh_fund = Fund.gsh
    donate = user.donates.build(amount: amount, fund: gsh_fund, promoter: promoter, pay_state: 'unpay')
    donate.save
    return donate
  end

  def wechat_prepay_js(remote_ip)
      prepay_id = get_wechat_prepay_id(remote_ip)
      package_str = "prepay_id=#{prepay_id}"
      prepay_js = {
        appId: Settings.wechat_app_id,
        nonceStr: SecureRandom.uuid.tr('-', ''),
        package: package_str,
        timeStamp: Time.now.getutc.to_i.to_s,
        signType: 'MD5'
      }
      pay_sign = WxPay::Sign.generate(prepay_js)
      prepay_js.merge(paySign: pay_sign)
    end

  # 捐定向
  def self.donate_project(user = nil, amount = 0.0, project = nil, promoter = nil)
    return false unless user.present?
    return false unless project.present?
    fund = project.fund
    donate = user.donates.build(amount: amount, fund: fund, promoter: promoter, pay_state: 'unpay', project: project, title: '捐助定向')
    donate.save
    return donate
  end

  # 捐可捐助
  def self.donate_donate_item(user: nil, amount: 0.0, income_record: nil, donate_item: nil, promoter: nil)
    return false unless user.present?
    return false unless donate_item.present?
    fund = donate_item.fund
    donate = user.donates.build(amount: amount, fund: fund, income_record: income_record, promoter: promoter, pay_state: 'unpay', donate_item: donate_item)
    donate.save
    return donate
  end

  # 捐指定
  def self.donate_apply(user: nil, amount: 0.0, income_record: nil, apply: nil, promoter: nil)
    return false unless apply.present?
    user_id = user.present? ? user.id : ''
    donate = DonateRecord.new(user_id: user_id, fund: apply.project.fund, income_record: income_record, promoter: promoter, pay_state: 'unpay', amount: amount, project: apply.project, season: apply.season, apply: apply)
    donate.save
    return donate
  end

  # 捐孩子
  def self.donate_child(user: nil, gsh_child: nil, income_record: nil, semester_num: 0, promoter: nil)
    # return false unless user.present?
    return false unless gsh_child.present?
    total = self.donate_child_total(gsh_child, semester_num)
    project = Project.pair_project
    user_id = user.present? ? user.id : nil
    donate = self.new(user_id: user_id, amount: total, fund: project.appoint_fund, income_record: income_record, promoter: promoter, pay_state: 'unpay', project: project, gsh_child: gsh_child)
    if donate.save! && ( scope = self.donate_child_semesters(gsh_child, semester_num))
      scope.update(donate_state: :succeed, user_id: user_id)
      gsh_child.update(donate_user_id: user_id)
    end
    return donate
  end

  # 捐悦读(整捐)
  def self.donate_bookshelf(user: nil, bookshelf: nil, income_record: nil, promoter: nil)
    return false unless user.present?
    return false unless bookshelf.present?
    return false if bookshelf.present_amount > 0
    project = Project.book_project
    donate = user.donates.build(amount: bookshelf.target_amount, promoter: promoter, income_record: income_record, fund: project.appoint_fund, project: project, bookshelf: bookshelf)
    if donate.save
      bookshelf.present_amount = bookshelf.target_amount
      bookshelf.state = 'complete'
      bookshelf.save
    end
  end

  # 捐悦读(零捐)
  def self.part_donate_bookshelf(user: nil, amount: 0, bookshelf: nil, income_record: nil, promoter: nil)
    return false unless bookshelf.present?
    project = Project.book_project
    user_id = user.present? ? user.id : ''
    DonateRecord.new(user_id: user_id, amount: amount, promoter: promoter, income_record: income_record, fund: project.appoint_fund, project: project, bookshelf: bookshelf)
  end

  def self.donate_child_semesters(gsh_child, semester_num)
    scope = gsh_child.semesters.pending.sorted.reverse_order
    return false if scope.count < semester_num || semester_num < 1
    scope.limit(semester_num)
  end

  def self.donate_child_total(gsh_child, semester_num)
    return self.donate_child_semesters(gsh_child, semester_num).to_a.sum {|a| a.amount}
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
    user = nil
    income_record = nil
    match_fund = nil
    amount = params[:amount]
    if params[:donate_way] == 'offline'
      income_record = IncomeRecord.has_balance.find(params[:offline_record_id])
      income_record.balance -= amount.to_f
      return false if income_record.balance < 0
    elsif params[:donate_way] == 'match'
      match_fund = Fund.find(params[:match_fund_id])
      match_fund.amount -= amount.to_f
      return false if match_fund.amount < 0
    elsif params[:donate_way] == 'balance'
      user = User.find(params[:balance_id])
      user.balance -= amount
      return false if user.balance < 0
    end

    self.transaction do
      begin
        donate_record = self.donate_apply(user: user, amount: amount, income_record: income_record, apply: apply, promoter: nil)
        donate_record.pay_state = 'paid'
        donate_record.kind = 'platform'

        apply.present_amount += amount.to_f
        apply.execute_state = 'to_delivery' if apply.present_amount == apply.target_amount

        donate_record.save!
        apply.save!
        match_fund.save! if match_fund.present?
        income_record.save! if income_record.present?
        user.save! if user.present?
        return true
      rescue
        return false
      end
    end
    return false
  end


  # 配捐给悦读
  def self.platform_donate_bookshelf(params, bookshelf)
    user = nil
    income_record = nil
    match_fund = nil
    amount = params[:amount]
    if params[:donate_way] == 'offline'
      income_record = IncomeRecord.has_balance.find(params[:offline_record_id])
      income_record.balance -= amount.to_f
      return false if income_record.balance < 0
    elsif params[:donate_way] == 'match'
      match_fund = Fund.find(params[:match_fund_id])
      match_fund.amount -= amount.to_f
      return false if match_fund.amount < 0
    elsif params[:donate_way] == 'balance'
      user = User.find(params[:balance_id])
      user.balance -= amount
      return false if user.balance < 0
    end
    self.transaction do
      begin
        donate_record = self.part_donate_bookshelf(user: user, amount: amount, income_record: income_record, bookshelf: bookshelf, promoter: nil)
        donate_record.pay_state = 'paid'
        donate_record.kind = 'platform'

        bookshelf.present_amount += amount
        bookshelf.state = 'complete' if bookshelf.present_amount == bookshelf.target_amount

        donate_record.save!
        bookshelf.save!
        income_record.save! if income_record.present?
        match_fund.save! if match_fund.present?
        user.save! if user.present?
        return true
      rescue
        return false
      end
    end
    return false
  end

  # 配捐给孩子
  def self.platform_donate_child(params, child)
    user = nil
    income_record = nil
    match_fund = nil
    semester_num = params[:grant_number].to_i
    amount = self.donate_child_total(child, semester_num)
    if params[:donate_way] == 'offline'
      income_record = IncomeRecord.has_balance.find(params[:offline_record_id])
      income_record.balance -= amount.to_f
      return false if income_record.balance < 0
    elsif params[:donate_way] == 'match'
      match_fund = Fund.find(params[:match_fund_id])
      match_fund.amount -= amount.to_f
      return false if match_fund.amount < 0
    elsif params[:donate_way] == 'balance'
      user = User.find(params[:balance_id])
      user.balance -= amount
      return false if user.balance < 0
    end

    self.transaction do
      begin
        donate_record = self.donate_child(user: user, gsh_child: child, income_record: income_record, semester_num: semester_num, promoter: nil)
        donate_record.pay_state = 'paid'
        donate_record.kind = 'platform'
        donate_record.save!
        income_record.save! if income_record.present?
        match_fund.save! if match_fund.present?
        user.save! if user.present?
        return true
      rescue
        return false
      end
    end
    return false
  end

  def gen_income_record
    self.build_income_record(donate_record: self, user: self.user, fund: self.fund, amount: amount, remitter_id: self.remitter_id, remitter_name: self.remitter_name, donor: self.donor, promoter_id: self.promoter_id, income_time: Time.now)
  end

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id, :donor, :donate_no, :remitter_name, :project_id)
      json.user_name self.user.present? ? self.user.name : '爱心人士'
      json.time self.created_at.strftime('%Y-%m-%d %H:%M:%S')
      json.amount number_to_currency(self.amount)
      json.item_name self.appoint.present? ? self.appoint.name : ''
      json.team self.team.present? ? self.team.name : ''
      json.project self.try(:project).try(:name)
      json.user_name self.try(:user).try(:name)
      json.donate_name self.try(:donate_item).try(:name) || self.try(:project).try(:name)
      json.apply_name self.try(:apply).try(:name)
      json.project_image self.try(:project).try(:project_image).to_s
      json.income_source self.try(:income_record).try(:income_source).try(:name)
      json.income_kind self.try(:income_record).try(:income_source).present? ? self.try(:income_record).try(:income_source).enum_name(:kind) : ''
    end.attributes!
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
      json.certificate self.donor_certificate_path
    end.attributes!
  end

  private
  def gen_donate_no
    time_string = Time.now.strftime("%y%m%d%H")
    self.donate_no ||= Sequence.get_seq(kind: :donate_no, prefix: time_string, length: 7)
  end

  def get_wechat_prepay_id(remote_ip)
    notify_url = Settings.app_host + "/payment/wechat_payments/notify"
    params = {
      body: '需要一个商品名称',
      out_trade_no: self.donate_no,
      # total_fee: Settings.pay_1_mode ? 1 : (self.amount * 100).to_i,
      total_fee: 1,
      # (self.amount * 100).to_i,
      spbill_create_ip: remote_ip,
      notify_url: notify_url,
      trade_type: 'JSAPI', # could be "JSAPI" or "NATIVE",
      openid: self.user.openid# required when trade_type is `JSAPI`
    }
    res = WxPay::Service.invoke_unifiedorder params
    return res['prepay_id']
  end

end
