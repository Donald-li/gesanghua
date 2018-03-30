# == Schema Information
#
# Table name: donate_records # 捐赠记录
#
#  id                                :integer          not null, primary key
#  donor_id                          :integer                                # 用户id
#  fund_id                           :integer                                # 基金ID
#  amount                            :decimal(14, 2)   default(0.0)          # 捐助金额
#  project_id                        :integer                                # 项目id
#  team_id                           :integer                                # 小组id
#  promoter_id                       :integer                                # 劝捐人
#  agent_id                          :integer                                # 汇款人id
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  project_season_id                 :integer                                # 年度ID
#  project_season_apply_id           :integer                                # 年度项目ID
#  project_season_apply_child_id     :integer                                # 年度孩子申请ID
#  gsh_child_id                      :integer                                # 格桑花孩子id
#  project_season_apply_bookshelf_id :integer                                # 书架id
#  donate_item_id                    :integer                                # 可捐助id
#  income_record_id                  :integer                                # 收入记录
#  title                             :string                                 # 捐赠标题
#  source_type                       :string
#  source_id                         :integer                                # 资金来源
#  owner_type                        :string
#  owner_id                          :integer                                # 捐助所属捐助项
#  donation_id                       :integer                                # 捐助id
#  kind                              :integer                                # 捐助方式 1:捐款 2:配捐
#

# 捐助记录
class DonateRecord < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :donor, class_name: 'User', foreign_key: 'donor_id', optional: true
  belongs_to :agent, class_name: 'User', foreign_key: 'agent_id', optional: true
  belongs_to :promoter, class_name: 'User', foreign_key: 'promoter_id', optional: true
  belongs_to :fund, optional: true
  belongs_to :project, optional: true
  belongs_to :season, class_name: 'ProjectSeason', foreign_key: 'project_season_id', optional: true
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: 'project_season_apply_id', optional: true
  belongs_to :child, class_name: 'ProjectSeasonApplyChild', foreign_key: 'project_season_apply_child_id', optional: true
  belongs_to :bookshelf, class_name: 'ProjectSeasonApplyBookshelf', foreign_key: 'project_season_apply_bookshelf_id', optional: true
  belongs_to :supplement, class_name: 'BookshelfSupplement', foreign_key: 'bookshelf_supplement_id', optional: true
  belongs_to :team, optional: true
  belongs_to :income_record, optional: true
  belongs_to :gsh_child, class_name: 'GshChild', optional: true

  counter_culture :project, column_name: proc{|model| model.project.present? && model.pay_state == 'paid' ? 'donate_record_amount_count' : nil}, delta_magnitude: proc {|model| model.amount}
  counter_culture :donor, column_name: proc{|model| model.user.present? && model.pay_state == 'paid' ? 'donate_count' : nil}, delta_magnitude: proc {|model| model.amount }
  counter_culture :promoter, column_name: proc{|model| model.promoter.present? && model.pay_state == 'paid' ? 'promoter_amount_count' : nil}, delta_magnitude: proc {|model| model.amount }
  counter_culture :team, column_name: proc{|model| model.team.present? && model.pay_state == 'paid' ? 'total_donate_amount' : nil}, delta_magnitude: proc {|model| model.amount }
  counter_culture :team, column_name: proc{|model| model.team.present? && model.pay_state == 'paid' ? 'current_donate_amount' : nil}, delta_magnitude: proc {|model| model.amount }
  counter_culture :apply, column_name: proc{|model| model.apply.present? && !model.apply.has_item? && model.pay_state == 'paid' ? 'present_amount' : nil}, delta_magnitude: proc {|model| model.amount }
  counter_culture :bookshelf, column_name: proc{|model| model.bookshelf.present? && model.pay_state == 'paid' ? 'present_amount' : nil}, delta_magnitude: proc {|model| model.amount }

  validates :amount, presence: true

  enum kind: {user_donate: 1, platform_donate: 2} # 记录类型: 1:用户捐款 2:平台配捐
  default_value_for :kind, 1

  scope :sorted, -> {order(created_at: :desc)}

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
    # self.donor_certificate_path # TODO 调用捐赠证书方法，生成证书（微信支付调通以后，需要考虑此方法的执行速度）
    self.save
  end

  #捐赠证书路径
  def donor_certificate_path
    self.certificate_no ||= 'ZS' + self.donate_no
    path = "/images/certificates/#{self.created_at.strftime('%Y%m%d')}/#{self.id}/#{Encryption.md5(self.id.to_s)}.jpg"
    local_path = Rails.root.to_s + '/public' + path
    if !File::exist?(local_path)
      GenDonateCertificate.create(self)
    end
    self.save
    path
  end

  def project_name
    self.project.try(:name) || '格桑花'
  end

  def donate_item_name
    self.donate_item.try(:name)
  end

  def donor_name
    self.donor || self.user.user_name
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


  # 处理捐款
  # kind: 用户捐款、平台配捐；source：资金来源； owner：捐助对象；amount：捐助金额
  def self.do_donate(kind, source, owner, amount)
    self.transaction do # 事务
      # 来源金额是否充足？
      if source.balance < amount
        return false
      else
        source.lock! # 加锁
      end
      donate_records = []

      #
      # 如果是捐到捐助项
      if owner.is_a?(DonateItem)
        donate_records << self.create!(source: source, kind: kind, owner: owner, amount: amount)
        owner.accept_donate(donate_records)
        source.balance -= amount
        source.save!

      # 如果捐到申请子项 （书架，孩子，补书，指定）
      elsif owner.class.name.in?(['GshChildGrant', 'ProjectSeasonApplyBookshelf'])
        donate_records << self.create!(source: source, kind: kind, owner: owner, amount: amount)
        owner.accept_donate(donate_records)
        source.balance -= amount
        source.save!

      # 如果是捐到申请（物资类项目，子项）
      elsif owner.class.name.in?(['ProjectSeasonApply', 'PProjectSeasonApplyChild'])
        # 物资或拓展营
        if owner.project.goods? || owner.project == Project.camp_project
          donate_records << self.create!(source: source, kind: kind, owner: owner, amount: amount)
          owner.accept_donate(donate_records)
          source.balance -= amount
          source.save!
        else
          # 如果是捐到申请（书架孩子补书，没选择子项）
          # 分解到子项，捐助到子项

          owner.get_donate_items.each do |item|
            if source.balance > item.surplus_money
              donate_records << self.create!(source: source, kind: kind, owner: owner, amount: amount)
              source.balance -= amount
              source.save!
              item.to_delivery!
            end
          end

      end

      donate_amount =  donate_records.sum{|r| r.amount}

      # 从source余额中扣款
      source.balance -= donate_amount

      # 判断是否超捐，超捐退回余额，并扣除income_record balance
      if kind == 'system' && source.is_a?(IncomeRecord)
        reback = amount - donate_amount
        source.balance -= reback
        user = source.user
        user.lock!
        user.balance += reback
        user.save!
      end
      source.save!
    end
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
  def self.donate_child(user: nil, child: nil, income_record: nil, semester_num: 0, promoter: nil)
    # return false unless user.present?
    return false unless child.present?
    total = self.donate_child_total(child, semester_num)
    project = Project.pair_project
    user_id = user.present? ? user.id : nil
    donate = self.new(user_id: user_id, amount: total, fund: project.appoint_fund, income_record: income_record, promoter: promoter, pay_state: 'unpay', project: project, season: child.season, apply: child.apply, child: child)
    if donate.save! && ( scope = self.donate_child_semesters(child, semester_num))
      scope.update(donate_state: :succeed, user_id: user_id)
      child.update(donate_user_id: user_id)
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

  def self.donate_child_semesters(child, semester_num)
    scope = child.semesters.pending.sorted.reverse_order
    return false if scope.count < semester_num || semester_num < 1
    scope.limit(semester_num)
  end

  def self.donate_child_total(child, semester_num)
    return self.donate_child_semesters(child, semester_num).to_a.sum {|a| a.amount}
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

  def self.use_income_record_donate_apply(income_record)
    return false unless income_record.has_balance?

    donate_record = income_record.donate_records.first
    apply = donate_record.apply

    return false unless apply.present?

    user = donate_record.user

    project = apply.project

    return false unless project.id == 2

    item = apply.bookshelves.raising.order(present_amount: :desc).first if apply.whole?
    item = apply.supplements.raising.sorted.first if apply.supplement? # ?

    unless item.present?
      self.transaction do
        begin
          user.balance += income_record.balance
          income_record.balance = 0
          user.save!
          income_record.save!
          return true
        rescue
          return false
        end
      end
    end

    if item.surplus_money >= income_record.balance
      self.transaction do
        begin
          dr = self.part_donate_bookshelf(user: user, amount: income_record.balance, income_record: income_record, bookshelf: item, promoter: nil)
          dr.pay_state = 'paid'
          dr.kind = 'platform'
          dr.save!
          income_record.balance = 0
          income_record.save!
        rescue
          return false
        end
      end
    else
      self.transaction do
        begin
          dr = self.part_donate_bookshelf(user: user, amount: item.surplus_money, income_record: income_record, bookshelf: item, promoter: nil)
          dr.pay_state = 'paid'
          dr.kind = 'platform'
          dr.save!
          income_record.balance -= item.surplus_money
          income_record.save!
        rescue
          return false
        end
      end
      income_record.reload
      self.use_income_record_donate_apply(income_record) if income_record.has_balance?
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
        donate_record = self.donate_child(user: user, child: child, income_record: income_record, semester_num: semester_num, promoter: nil)
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
      json.apply_name self.apply.try(:name)
      json.apply_image_mode self.apply.try(:cover_image).present?
      json.apply_image self.apply.cover_image_url(:little).to_s if self.apply && self.apply.cover_image
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



  private

  def get_donate_record_info
    self.project = self.owner.project if self.owner.project.present?
    self.season = self.owner.season if self.owner.season.present?
    self.apply = self.owner.apply if self.owner.apply.present?
    self.child = self.owner.child if self.owner.child.present?
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
