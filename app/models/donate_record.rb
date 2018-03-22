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

  before_create :set_record_title

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

  counter_culture :project, column_name: proc{|model| model.project.present? && model.pay_state == 'paid' ? 'donate_record_amount_count' : nil}, delta_magnitude: proc {|model| model.amount}
  counter_culture :user, column_name: proc{|model| model.user.present? && model.pay_state == 'paid' ? 'donate_count' : nil}, delta_magnitude: proc {|model| model.amount }
  counter_culture :promoter, column_name: proc{|model| model.promoter.present? && model.pay_state == 'paid' ? 'promoter_amount_count' : nil}, delta_magnitude: proc {|model| model.amount }
  counter_culture :team, column_name: proc{|model| model.team.present? && model.pay_state == 'paid' ? 'total_donate_amount' : nil}, delta_magnitude: proc {|model| model.amount }
  counter_culture :team, column_name: proc{|model| model.team.present? && model.pay_state == 'paid' ? 'current_donate_amount' : nil}, delta_magnitude: proc {|model| model.amount }

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

  # 生成捐赠编号
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

  # 返回微信支付js
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

  # 返回微信支付按钮
  def wechat_prepay_h5(remote_ip)
    return get_wechat_prepay_mweb(remote_ip)
  end

  # 返回支付宝支付按钮
  def alipay_prepay_h5
    return get_alipay_prepay_mweb
  end

  # 捐定向
  def self.donate_project(user = nil, amount = 0.0, project = nil, promoter = nil, item = nil)
    return false unless user.present?
    return false unless project.present?
    fund = project.fund
    donate = user.donates.build(amount: amount, fund: fund, promoter: promoter, pay_state: 'unpay', project: project, title: "捐助#{project.name}定向")
    donate.team_id = user.team_id
    appoint = project.children.find(item) if item.present? && project.id == 1 # 孩子
    appoint = project.bookshelves.find(item) if item.present? && project.id == 2 # 书架
    if appoint.present?
      donate.appoint = appoint
      donate.apply = appoint.apply
      donate.season = appoint.season
    end
    donate.save
    return donate
  end

  # 捐可捐助
  def self.donate_donate_item(user: nil, amount: 0.0, income_record: nil, donate_item: nil, promoter: nil)
    return false unless user.present?
    return false unless donate_item.present?
    fund = donate_item.fund
    donate = user.donates.build(amount: amount, fund: fund, income_record: income_record, promoter: promoter, pay_state: 'unpay', donate_item: donate_item)
    donate.project = donate_item.project if donate_item.project.present?
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
    donate = self.new(user_id: user_id, amount: total, fund: project.appoint_fund, income_record: income_record, promoter: promoter, pay_state: 'unpay', project: project, season: gsh_child.season, apply: gsh_child.apply, gsh_child: gsh_child)
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
    project = Project.read_project
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
    project = Project.read_project
    user_id = user.present? ? user.id : ''
    DonateRecord.new(user_id: user_id, amount: amount, promoter: promoter, income_record: income_record, fund: project.appoint_fund, project: project, bookshelf: bookshelf)
  end

  # 捐悦读补书
  def self.donate_supplement(user: nil, amount: 0, supplement: nil, income_record: nil, promoter: nil)
    return false unless supplement.present?
    project = Project.read_project
    user_id = user.present? ? user.id : ''
    DonateRecord.new(user_id: user_id, amount: amount, promoter: promoter, income_record: income_record, fund: project.appoint_fund, project: project, supplement: supplement)
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

  # 散捐书架
  def self.use_income_record_donate_bookshelf(params, income_record)
    donate_record = income_record.donate_records.system.first
    apply = donate_record.apply
    user = income_record.user

    if apply.project_id == 2 && apply.whole?
      bookshelves = apply.bookshelves.raising.sorted
      bookshelves.each do |bookshelf|
        amount = bookshelf.target_amount - bookshelf.present_amount
        donate_amount = amount

        if income_record.balance - amount < 0
          donate_amount = income_record.balance
        end
        if self.platform_donate_bookshelf(params.merge(amount: amount, donate_way: 'offline', offline_record_id: income_record.id), bookshelf)
          income_record.balance -= donate_amount
          income_record.save
        end
      end

      if income_record.balance > 0
        user.balance += income_record.balance
        user.save
      end

    end
  end

  # 配捐给悦读
  def self.platform_donate_bookshelf(params, bookshelf)
    user = nil
    income_record = nil
    match_fund = nil
    amount = bookshelf.target_amount - bookshelf.present_amount
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
        bookshelf.state = 'to_delivery' if bookshelf.present_amount == bookshelf.target_amount

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

  # 配捐给悦读补书
  def self.platform_donate_supplement(params, supplement)
    user = nil
    income_record = nil
    match_fund = nil
    amount = supplement.target_amount - supplement.present_amount
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
        donate_record = self.donate_supplement(user: user, amount: amount, income_record: income_record, supplement: supplement, promoter: nil)
        donate_record.pay_state = 'paid'
        donate_record.kind = 'platform'

        supplement.present_amount += amount
        supplement.state = 'to_delivery' if supplement.present_amount == supplement.target_amount

        donate_record.save!
        supplement.save!
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
    income_record = self.build_income_record(user: self.user, fund: self.fund, amount: amount, remitter_id: self.remitter_id, remitter_name: self.remitter_name, donor: self.donor, promoter_id: self.promoter_id, income_time: Time.now)
    self.income_record = income_record
    self.save
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :donor, :donate_no, :title)
      json.time self.created_at.strftime('%Y-%m-%d %H:%M:%S')
      json.amount number_to_currency(self.amount)
      json.amount_float self.amount
      json.donate_mode !self.donor.present? # true自己捐 false代捐
      json.donate_title self.user.name === self.donor ? '' : '代捐' # true自己捐 false代捐
    end.attributes!
  end

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id, :donor, :donate_no, :remitter_name, :project_id, :pay_state, :promoter_id)
      json.user_name self.user.present? ? self.user.name : '爱心人士'
      json.user_avatar self.user.try(:user_avatar)
      json.time self.created_at.strftime('%Y-%m-%d %H:%M:%S')
      json.amount number_to_currency(self.amount)
      json.item_name self.appoint.present? ? self.appoint.name : ''
      json.by_team self.team.present?
      json.team_name self.team.present? ? self.team.name : ''
      json.project self.try(:project).try(:name)
      json.donate_name self.try(:donate_item).try(:name) || self.try(:project).try(:name)
      json.apply_name self.try(:apply).try(:name)
      json.project_image_mode self.try(:project).try(:image).present?
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

  def promoter_record_builder
    Jbuilder.new do |json|
      json.(self, :id)
      json.amount number_to_currency(self.amount)
      json.created_at self.created_at.strftime("%Y-%m-%d %H:%M:%S")
      json.user_name self.user.present? ? self.user.name : '爱心人士'
      json.fund_name self.try(:fund).try(:name)
      json.project_name self.try(:project).try(:name)
      json.apply_name self.try(:apply).try(:name)
      json.child_name self.try(:child).try(:name)
      json.show_name self.donate_apply_name
      json.promoter_amount_count number_to_currency(self.promoter.promoter_amount_count)
    end.attributes!
  end

  def donate_apply_name
    if self.apply.present?
      self.apply.try(:name)
    elsif self.child.present?
      self.child.try(:name)
    elsif self.fund.present?
      self.fund.fund_category.try(:name)
    end
  end

  def set_record_title
    return if self.title.present?
    self.title ||= "#{self.try(:user).try(:name)}捐助#{self.try(:donate_item).try(:name)}#{self.try(:donate_item).try(:fund).try(:name)}款项"
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

  def get_wechat_prepay_mweb(remote_ip)
    notify_url = Settings.app_host + "/payment/wechat_payments/notify"
    params = {
      body: '需要一个商品名称',
      out_trade_no: self.donate_no,
      # total_fee: Settings.pay_1_mode ? 1 : (self.amount * 100).to_i,
      total_fee: 1,
      # (self.amount * 100).to_i,
      spbill_create_ip: remote_ip,
      notify_url: notify_url,
      trade_type: 'MWEB', # could be "JSAPI" or "NATIVE",
      openid: self.user.openid# required when trade_type is `JSAPI`
    }
    res = WxPay::Service.invoke_unifiedorder params
    return res['mweb_url']
  end

  def get_alipay_prepay_mweb
    require 'alipay'
    notify_url = Settings.app_host + "/payment/alipay_payments/notify"
    quit_url = Settings.app_host + '/m/'

    @client = Alipay::Client.new(
      url: Settings.alipay_api,
      app_id: Settings.alipay_app_id,
      app_private_key: Settings.alipay_app_private_key,
      alipay_public_key: Settings.alipay_public_key
    )
    url = @client.page_execute_url(
      method: 'alipay.trade.wap.pay',
      return_url: quit_url,
      notify_url: notify_url,
      biz_content: {
       out_trade_no: self.donate_no,
       product_code: 'QUICK_WAP_WAY',
       total_amount: '0.01',
       subject: 'Example: 456',
       quit_url: quit_url
      }.to_json
    )
  end

end
