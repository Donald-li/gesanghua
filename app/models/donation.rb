# == Schema Information
#
# Table name: donations # 捐助表
#
#  id                      :bigint(8)        not null, primary key
#  donor_id                :integer                                # 捐助人id
#  owner_type              :string
#  owner_id                :bigint(8)                              # 捐助所属模型
#  pay_state               :integer                                # 支付状态
#  project_id              :integer                                # 项目id
#  project_season_id       :integer                                # 批次/年度id
#  project_season_apply_id :integer                                # 申请id
#  order_no                :string                                 # 订单编号
#  title                   :string                                 # 标题
#  promoter_id             :integer                                # 劝捐人
#  team_id                 :integer                                # 团队id
#  pay_result              :text                                   # 支付接口返回的支付接口数据
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  details                 :jsonb                                  # 捐助详情
#  amount                  :decimal(14, 2)   default(0.0)          # 捐助金额
#  agent_id                :integer                                # 代理人id
#  pay_way                 :integer                                # 支付方式
#  message                 :text                                   # 留言
#

# 捐助
class Donation < ApplicationRecord

  before_create :set_assoc_attrs, :set_record_title, :generate_order_no

  include ActionView::Helpers::NumberHelper

  has_one :income_record, dependent: :nullify
  has_many :donate_records, dependent: :nullify
  belongs_to :donor, class_name: 'User', foreign_key: 'donor_id', optional: true
  belongs_to :agent, class_name: 'User', foreign_key: 'agent_id', optional: true
  belongs_to :promoter, class_name: 'User', foreign_key: 'promoter_id', optional: true
  belongs_to :team, optional: true
  belongs_to :project, class_name: 'Project', optional: true
  belongs_to :season, class_name: 'ProjectSeason', foreign_key: :project_season_id, optional: true
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: :project_season_apply_id, optional: true
  belongs_to :owner, polymorphic: true
  belongs_to :donate_item, optional: true

  enum pay_way: { wechat: 1, alipay: 2}
  # default_value_for :pay_way, 1

  enum pay_state: { unpaid: 1, paid: 2}
  default_value_for :pay_state, 1

  # validates :order_no, presence: true

  scope :sorted, -> {order(id: :desc)}

  # 代捐人名称
  def agent_name
    return '无' if self.agent.blank?
    self.agent_id == self.donor_id ? '无' : self.agent.try(:show_name)
  end

  def can_name_shelf?
    self.owner_type == 'ProjectSeasonApplyBookshelf' && self.owner.target_amount == self.amount && self.owner.title.nil?
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

  # 返回微信h5支付按钮地址
  def wechat_prepay_h5(remote_ip)
    return get_wechat_prepay_mweb(remote_ip)
  end

  # 返回微信二维码支付地址
  def wechat_prepay_code(remote_ip)
    return get_wechat_prepay_code(remote_ip)
  end

  def self.batch_wechat_perpay_code(remote_ip, order_no, total)
    notify_url = Settings.app_host + "/payment/wechat_payments/batch_notify"
    params = {
        body: '捐助给格桑花',
        out_trade_no: order_no,
        total_fee: Settings.pay_1_mode ? 1 : (total * 100).to_i,
        # total_fee: 1,
        spbill_create_ip: remote_ip,
        notify_url: notify_url,
        trade_type: 'NATIVE', # could be "JSAPI" or "NATIVE",
        product_id: order_no,
        is_subscribe: 'Y'
    }
    res = WxPay::Service.invoke_unifiedorder params
    return res['code_url']
  end

  # 返回支付宝支付按钮
  def alipay_prepay_h5
    # return get_alipay_prepay_url(type='wap')
    Alipay::Service.create_direct_pay_by_user_wap_url(
      # service: 'create_donate_trade_p',
      payment_type: 4,
      out_trade_no: self.order_no,
      subject: '捐助给格桑花',
      total_fee: Settings.pay_1_mode ? '0.01' : sprintf('%.2f', self.amount.to_f),
      return_url: 'http://' + Settings.app_host + '/m/donate-result?order_no=' + self.order_no,
      notify_url: "http://" + Settings.app_host + "/payment/alipay_payments/notify"
    )
  end

  # 返回PC端支付宝支付按钮
  def alipay_prepay_page
    # return get_alipay_prepay_url(type='page')
    Alipay::Service.create_direct_pay_by_user_url(
      service: 'create_donate_trade_p',
      payment_type: 4,
      out_trade_no: self.order_no,
      subject: '捐助给格桑花',
      total_fee: Settings.pay_1_mode ? '0.01' : sprintf('%.2f', self.amount.to_f),
      return_url: 'http://' + Settings.app_host + '/pay?order_no=' + self.order_no,
      notify_url: "http://" + Settings.app_host + "/payment/alipay_payments/notify"
    )
  end

  def self.batch_alipay_prepay_page(order_no, total)
    Alipay::Service.create_direct_pay_by_user_url(
        service: 'create_donate_trade_p',
        payment_type: 4,
        out_trade_no: order_no,
        subject: '捐助给格桑花',
        total_fee: Settings.pay_1_mode ? '0.01' : sprintf('%.2f', total.to_f),
        return_url: 'http://' + Settings.app_host + '/pay/batch_result?order_no=' + order_no,
        notify_url: "http://" + Settings.app_host + "/payment/alipay_payments/batch_notify"
    )
  end

  # 项目是否可以退款
  def can_refund?
    self.paid? && self.user && self.system?
  end

  # 退款
  def do_refund!(operator)
    user = self.user
    return unless user
    self.transaction do
      begin
        User.update_counters(user.id, self.amount)
        self.pay_state = :refund
        # TODO: 还得处理income_record等
        self.save!
        return true
      rescue
        return false
      end
    end
  end

  # 对应的财务分类
  def income_fund
    if self.owner_type == 'CampaignEnlist'
      return self.owner.try(:campaign).try(:appoint_fund)
    elsif self.owner_type == 'DonateItem'
      return self.owner.try(:fund)
    elsif self.owner.try(:camp).present?
      return self.owner.camp.fund
    else
      self.project.try(:fund)
    end
  end

  # 微信-支付成功
  def self.wechat_payment_success(result)
    # TODO: 这里也应该加到事务里
    donation = Donation.find_by(order_no: result['out_trade_no'])
    # 订单重复不在创建
    # 处理订单重复
    donations = Donation.where(order_no: result['out_trade_no'])
    donations.each do |d|
      if d.income_record.present?
        return true
      end
    end
    logger.info "+++++++++donation_id#{donation.id}++#{result['out_trade_no']}+++++++"
    if donation.unpaid?
      donor = donation.donor
      agent = donation.agent
      amount = format('%.2f', (result['total_fee'].to_f / 100.to_f))
      amount = donation.amount if Settings.pay_1_mode # 测试模式入账金额等于捐助金额

      # 更新捐助状态
      donation.pay_state = 'paid'
      donation.pay_result = result.to_json
      if donation.income_record.blank?
        donation.create_income_record(fund: donation.income_fund, agent: agent, donor: donor, amount: amount, promoter_id: donation.promoter_id, team_id: donation.team_id, balance: amount, voucher_state: 'to_bill', income_source_id: IncomeSource.wechat_id, income_time: Time.now, title: donation.title)
      end
      donation.save

      # 执行捐助
      income_record = donation.income_record
      DonateRecord.do_donate('user_donate', income_record, donation.owner, amount, {agent: agent, donor: donor, promoter_id: donation.promoter_id, team_id: donation.team_id, message: donation.message})

      owner = income_record
      title = '#支付成功# 感谢您的支持'
      content = "感谢你的支持 捐助款已经收到，后续动态我们会持续通知"
      notice = Notification.create(
        kind: 'donate',
        owner: owner,
        project_id: donation.project_id,
        project_season_id: donation.project_season_id,
        project_season_apply_id: donation.project_season_apply_id,
        user_id: agent.id,
        title: title,
        content: content,
        url: "#{Settings.m_root_url}/account/"
      )
    end
  end

  # 微信-支付成功
  def self.batch_wechat_payment_success(result)
    # TODO: 这里也应该加到事务里
    donations = Donation.where(order_no: result['out_trade_no'])
    donations.each do |donation|
      if donation.unpaid?
        donor = donation.donor
        agent = donation.agent
        # amount = format('%.2f', (result['total_fee'].to_f / 100.to_f))
        amount = donation.amount # if Settings.pay_1_mode # 测试模式入账金额等于捐助金额

        # 更新捐助状态
        donation.pay_state = 'paid'
        donation.pay_result = result.to_json
        donation.build_income_record(fund: donation.income_fund, agent: agent, donor: donor, amount: amount, promoter_id: donation.promoter_id, team_id: donation.team_id, balance: amount, voucher_state: 'to_bill', income_source_id: IncomeSource.wechat_id, income_time: Time.now, title: donation.title)
        donation.save

        # 执行捐助
        income_record = donation.income_record
        DonateRecord.do_donate('user_donate', income_record, donation.owner, amount, {agent: agent, donor: donor, promoter_id: donation.promoter_id, team_id: donation.team_id, message: donation.message})

        owner = income_record
        title = '#支付成功# 感谢您的支持'
        content = "感谢你的支持 捐助款已经收到，后续动态我们会持续通知"
        notice = Notification.create(
            kind: 'donate',
            owner: owner,
            project_id: donation.project_id,
            project_season_id: donation.project_season_id,
            project_season_apply_id: donation.project_season_apply_id,
            user_id: agent.id,
            title: title,
            content: content,
            url: "#{Settings.m_root_url}/account/"
        )
      end
    end

  end

  # 支付宝-支付成功
  def self.alipay_payment_success(result)
    # TODO: 这里也应该加到事务里
    donation = Donation.find_by(order_no: result['out_trade_no'])
    if donation.unpaid?
      donor = donation.donor
      agent = donation.agent
      amount = donation.amount
      # amount = result['receipt_amount']
      # amount = donation.amount if Settings.pay_1_mode # 测试模式入账金额等于捐助金额

      # 更新捐助状态
      donation.pay_state = 'paid'
      donation.pay_result = result.to_json
      donation.build_income_record(fund: donation.income_fund, agent: agent, donor: donor, amount: amount, promoter_id: donation.promoter_id, team_id: donation.team_id, balance: amount, voucher_state: 'to_bill', income_source_id: IncomeSource.alipay_id, income_time: Time.now, title: donation.title)
      donation.save

      # 执行捐助
      income_record = donation.income_record
      DonateRecord.do_donate('user_donate', income_record, donation.owner, amount, {agent: agent, donor: donor, promoter_id: donation.promoter_id, team_id: donation.team_id, message: donation.message})

      owner = income_record
      title = '#支付成功# 感谢您的支持'
      content = "感谢你的支持！捐助款已经收到，后续动态我们会持续通知"
      notice = Notification.create(
        kind: 'donate',
        project_id: donation.project_id,
        project_season_id: donation.project_season_id,
        project_season_apply_id: donation.project_season_apply_id,
        owner: owner,
        user_id: agent.id,
        title: title,
        content: content,
        url: "#{Settings.m_root_url}/account/"
      )
    end
  end

  # 支付宝-支付成功
  def self.batch_alipay_payment_success(result)
    # TODO: 这里也应该加到事务里
    donations = Donation.where(order_no: result['out_trade_no'])
    donations.each do |donation|
      if donation.unpaid?
        donor = donation.donor
        agent = donation.agent
        amount = donation.amount
        # amount = result['receipt_amount']
        # amount = donation.amount if Settings.pay_1_mode # 测试模式入账金额等于捐助金额

        # 更新捐助状态
        donation.pay_state = 'paid'
        donation.pay_result = result.to_json
        donation.build_income_record(fund: donation.income_fund, agent: agent, donor: donor, amount: amount, promoter_id: donation.promoter_id, team_id: donation.team_id, balance: amount, voucher_state: 'to_bill', income_source_id: IncomeSource.alipay_id, income_time: Time.now, title: donation.title)
        donation.save

        # 执行捐助
        income_record = donation.income_record
        DonateRecord.do_donate('user_donate', income_record, donation.owner, amount, {agent: agent, donor: donor, promoter_id: donation.promoter_id, team_id: donation.team_id, message: donation.message})

        owner = income_record
        title = '#支付成功# 感谢您的支持'
        content = "感谢你的支持！捐助款已经收到，后续动态我们会持续通知"
        notice = Notification.create(
            kind: 'donate',
            project_id: donation.project_id,
            project_season_id: donation.project_season_id,
            project_season_apply_id: donation.project_season_apply_id,
            owner: owner,
            user_id: agent.id,
            title: title,
            content: content,
            url: "#{Settings.m_root_url}/account/"
        )
      end
    end
  end

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id, :order_no, :amount, :pay_state)
      json.certificate_no self.income_record.try(:certificate_no)
      if ['ProjectSeasonApplyBookshelf', 'BookshelfSupplement'].include?(self.owner_type)
        json.bookshelf self.owner_id
      end
    end.attributes!
  end

  def donate_apply_name
    if self.apply.present?
      self.apply.try(:name)
    elsif self.owner.is_a?(ProjectSeasonApplyChild)
      self.owner.name
    else
      '捐助'
    end
  end

  # 募捐信息
  def promoter_record_builder
    Jbuilder.new do |json|
      json.(self, :id)
      json.amount number_to_currency(self.amount)
      json.created_at self.created_at.strftime("%Y-%m-%d %H:%M:%S")
      json.user_name self.donor.try(:user_name) || '爱心人士'
      json.project_name self.try(:project).try(:name)
      json.apply_name self.try(:apply).try(:name)
      json.child_name self.try(:owner).try(:name) if self.owner_type == 'ProjectSeasonApplyChild'
      json.show_name self.donate_apply_name
      json.promoter_amount_count number_to_currency(self.promoter.promoter_amount_count)
    end.attributes!
  end

  def set_record_title(force: false)
    return if self.title.present? && !force
    if self.owner_type == 'DonateItem'
      self.title = "捐助#{self.try(:owner).try(:name)}款项"
    elsif self.owner_type == 'CampaignEnlist'
      self.title = "捐助#{self.owner.try(:campaign).try(:name)}活动款项"
    else
      self.title = "捐助#{self.try(:apply).try(:apply_name)}#{self.try(:child).try(:name)}#{self.try(:bookshelf).try(:show_title)}款项"
    end
  end

  private
  def generate_order_no
    time_string = Time.now.strftime("%y%m%d%H")
    self.order_no ||= Sequence.get_seq(kind: :order_no, prefix: time_string, length: 7)
  end

  def get_wechat_prepay_id(remote_ip)
    notify_url = Settings.app_host + "/payment/wechat_payments/notify"
    params = {
      body: '捐助给格桑花',
      out_trade_no: self.order_no,
      total_fee: Settings.pay_1_mode ? 1 : (self.amount * 100).to_i,
      # total_fee: 1,
      spbill_create_ip: remote_ip,
      notify_url: notify_url,
      trade_type: 'JSAPI', # could be "JSAPI" or "NATIVE",
      openid: self.agent.profile['openid'] # required when trade_type is `JSAPI`
    }
    res = WxPay::Service.invoke_unifiedorder params
    logger.info '+++++++++ wechat prepay id +++++++++'
    logger.info(res.inspect)
    return res['prepay_id']
  end

  def get_wechat_prepay_mweb(remote_ip)
    notify_url = Settings.app_host + "/payment/wechat_payments/notify"
    params = {
      body: '捐助给格桑花',
      out_trade_no: self.order_no,
      total_fee: Settings.pay_1_mode ? 1 : (self.amount * 100).to_i,
      # total_fee: 1,
      spbill_create_ip: remote_ip,
      notify_url: notify_url,
      trade_type: 'MWEB', # could be "JSAPI" or "NATIVE",
      openid: self.agent.profile['openid']# required when trade_type is `JSAPI`
    }
    res = WxPay::Service.invoke_unifiedorder params
    return res['mweb_url']
  end

  def get_wechat_prepay_code(remote_ip)
    notify_url = Settings.app_host + "/payment/wechat_payments/notify"
    params = {
      body: '捐助给格桑花',
      out_trade_no: self.order_no,
      total_fee: Settings.pay_1_mode ? 1 : (self.amount * 100).to_i,
      # total_fee: 1,
      spbill_create_ip: remote_ip,
      notify_url: notify_url,
      trade_type: 'NATIVE', # could be "JSAPI" or "NATIVE",
      product_id: self.order_no,
      is_subscribe: 'Y'
    }
    res = WxPay::Service.invoke_unifiedorder params
    return res['code_url']
  end

  # 返回一个支付宝对象
  def get_alipay_client
    client = Alipay::Client.new(
      url: Settings.alipay_api,
      app_id: Settings.alipay_app_id,
      app_private_key: Settings.alipay_app_private_key,
      alipay_public_key: Settings.alipay_public_key
    )
    client
  end

  # 得到一个支付宝链接 type: {wap|page}
  # 新接口，暂时不支持公益，没使用
  def get_alipay_prepay_url(type='wap')
    require 'alipay'
    notify_url = "http://" + Settings.app_host + "/payment/alipay_payments/notify"

    if type == 'wap'
      method = "alipay.trade.wap.pay"
      product_code = 'QUICK_WAP_WAY'
      quit_url = 'http://' + Settings.app_host + '/m/donate-result?order_no=' + self.order_no
    else
      method = "alipay.trade.page.pay"
      # method = "create_donate_trade_p"
      product_code = 'FAST_INSTANT_TRADE_PAY'
      quit_url = 'http://' + Settings.app_host + '/pay?order_no=' + self.order_no
    end

    @client = get_alipay_client
    url = @client.page_execute_url(
      method: method,
      return_url: quit_url,
      notify_url: notify_url,
      biz_content: {
       out_trade_no: self.order_no,
       product_code: product_code,
       total_amount: Settings.pay_1_mode ? '0.01' : sprintf('%.2f', self.amount.to_f),
       subject: '捐助给格桑花',
       payment_type: 4,
       quit_url: quit_url
      }.to_json
    )
  end

  # 设置关联的外键
  def set_assoc_attrs
    case self.owner
    when GshChildGrant
      self.project_season_apply_id = self.owner.project_season_apply_id
      self.project_season_id = self.apply.try(:project_season_id)
      self.project_id = Project.pair_project.id
    when ProjectSeasonApplyChild, ProjectSeasonApplyBookshelf
      self.project_id = self.owner.project_id
      self.project_season_id = self.owner.project_season_id
      self.project_season_apply_id = self.owner.project_season_apply_id
    when ProjectSeasonApply
      self.project_id = self.owner.project_id
      self.project_season_id = self.owner.project_season_id
      self.project_season_apply_id = self.owner_id
    when BookshelfSupplement
      self.project_id = self.owner.project_id
      self.project_season_apply_id = self.owner.try(:project_season_apply_id)
    when DonateItem
      self.project_id = self.owner.project.try(:id)
    end
  end
end
