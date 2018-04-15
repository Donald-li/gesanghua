# == Schema Information
#
# Table name: donations # 捐助表
#
#  id                      :integer          not null, primary key
#  donor_id                :integer                                # 捐助人id
#  owner_type              :string
#  owner_id                :integer                                # 捐助所属模型
#  pay_state               :integer                                # 支付状态
#  voucher_state           :integer                                # 捐赠收据状态
#  project_id              :integer                                # 项目id
#  project_season_id       :integer                                # 批次/年度id
#  project_season_apply_id :integer                                # 申请id
#  order_no                :string                                 # 订单编号
#  certificate_no          :string                                 # 捐赠证书编号
#  title                   :string                                 # 标题
#  promoter_id             :integer                                # 劝捐人
#  team_id                 :integer                                # 团队id
#  pay_result              :text                                   # 支付接口返回的支付接口数据
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  details                 :jsonb                                  # 捐助详情
#  amount                  :decimal(14, 2)   default(0.0)          # 捐助金额
#  agent_id                :integer                                # 代理人id
#

# 捐助
class Donation < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  has_many :income_records, dependent: :nullify
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

  before_create :set_record_title
  before_create :generate_order_no

  enum pay_state: { unpaid: 1, paid: 2}
  default_value_for :pay_state, 1

  scope :sorted, -> {order(id: :desc)}

  # owner的名称
  def project_name
    self.project.try(:name) || '格桑花'
  end

  # 生成收入
  def gen_income_record
    income_record = self.build_income_record(user: self.user, fund: self.fund, amount: amount, remitter_id: self.remitter_id, remitter_name: self.remitter_name, donor: self.donor, promoter_id: self.promoter_id, income_time: Time.now)
    self.income_record = income_record
    self.save
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

  # 返回支付宝支付按钮
  def alipay_prepay_h5
    return get_alipay_prepay_url('wap')
  end

  # 返回PC端支付宝支付按钮
  def alipay_prepay_page
    return get_alipay_prepay_url('page')
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

  # 支付成功
  def self.wechat_payment_success(result)
    donation = Donation.find_by(order_no: result['out_trade_no'])
    if donation.unpaid?
      donor = donation.donor
      agent = donation.agent
      amount = format('%.2f', (result['total_fee'].to_f / 100.to_f))
      amount = donation.amount if Settings.pay_1_mode # 测试模式入账金额等于捐助金额

      # 更新捐助状态
      donation.pay_state = 'paid'
      donation.pay_result = result.to_json
      donation.gen_certificate_no(save: false)
      donation.income_records.new(agent: agent, donor: donor, amount: amount, balance: amount, voucher_state: 'to_bill', income_source_id: 1, income_time: Time.now)
      donation.save

      # 执行捐助
      income_record = donation.income_records.last
      DonateRecord.do_donate('user_donate', income_record, donation.owner, amount, {agent: agent, donor: donor})
    end
  end

  # 生成捐赠编号
  def gen_certificate_no(save: false)
    self.certificate_no ||= 'ZS' + self.order_no
    self.pay_state = 'paid'
    # self.donor_certificate_path # TODO 调用捐赠证书方法，生成证书（微信支付调通以后，需要考虑此方法的执行速度）
    self.save if save
  end

  #捐赠证书路径
  def donor_certificate_path
    self.certificate_no ||= 'ZS' + self.order_no
    path = "/images/certificates/#{self.created_at.strftime('%Y%m%d')}/#{self.id}/#{Encryption.md5(self.id.to_s)}.jpg"
    local_path = Rails.root.to_s + '/public' + path
    if !File::exist?(local_path)
      GenDonateCertificate.create(self)
    end
    self.save
    path
  end

  def certificate_builder
    Jbuilder.new do |json|
      json.(self, :certificate_no)
      json.certificate self.donor_certificate_path
    end.attributes!
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

  def apply_cover
    if self.project_id == Project.pair_project.id
      self.try(:project).project_image
    else
      self.try(:apply).try(:cover_image_url, :small)
    end

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

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id, :amount, :title, :order_no, :certificate_no)
      json.time self.created_at.strftime('%Y-%m-%d %H:%M:%S')
      json.donate_mode !self.donor.present? # true自己捐 false代捐
      json.donate_title self.donor_id === self.agent_id ? '' : '代捐' # true自己捐 false代捐
      json.agent self.agent.try(:show_name)
      json.donor self.donor.show_name
      json.userAvatar self.agent.user_avatar
      json.apply_cover apply_cover
      json.apply_name donate_apply_name
      json.bookshelf self.owner_id if self.owner_type == 'ProjectSeasonApplyBookshelf'
    end.attributes!
  end

  private
  def set_record_title
    return if self.title.present?
    if self.donate_item.present?
      self.title = "#{self.try(:donor).try(:name)}捐助#{self.try(:donate_item).try(:name)}#{self.try(:donate_item).try(:fund).try(:name)}款项"
    else
      self.title = "#{self.try(:donor).try(:name)}捐助#{self.try(:apply).try(:apply_name)}#{self.try(:child).try(:name)}#{self.try(:bookshelf).try(:show_title)}款项"
    end
  end

  def generate_order_no
    time_string = Time.now.strftime("%y%m%d%H")
    self.order_no ||= Sequence.get_seq(kind: :order_no, prefix: time_string, length: 7)
  end

  def get_wechat_prepay_id(remote_ip)
    notify_url = Settings.app_host + "/payment/wechat_payments/notify"
    params = {
      body: '需要一个商品名称',
      out_trade_no: self.order_no,
      # total_fee: Settings.pay_1_mode ? 1 : (self.amount * 100).to_i,
      total_fee: 1,
      # (self.amount * 100).to_i,
      spbill_create_ip: remote_ip,
      notify_url: notify_url,
      trade_type: 'JSAPI', # could be "JSAPI" or "NATIVE",
      openid: self.agent.openid# required when trade_type is `JSAPI`
    }
    res = WxPay::Service.invoke_unifiedorder params
    return res['prepay_id']
  end

  def get_wechat_prepay_mweb(remote_ip)
    notify_url = Settings.app_host + "/payment/wechat_payments/notify"
    params = {
      body: '需要一个商品名称',
      out_trade_no: self.order_no,
      # total_fee: Settings.pay_1_mode ? 1 : (self.amount * 100).to_i,
      total_fee: 1,
      # (self.amount * 100).to_i,
      spbill_create_ip: remote_ip,
      notify_url: notify_url,
      trade_type: 'MWEB', # could be "JSAPI" or "NATIVE",
      openid: self.agent.openid# required when trade_type is `JSAPI`
    }
    res = WxPay::Service.invoke_unifiedorder params
    return res['mweb_url']
  end

  def get_wechat_prepay_code(remote_ip)
    notify_url = Settings.app_host + "/payment/wechat_payments/notify"
    params = {
      body: '需要一个商品名称',
      out_trade_no: self.order_no,
      # total_fee: Settings.pay_1_mode ? 1 : (self.amount * 100).to_i,
      total_fee: 1,
      # (self.amount * 100).to_i,
      spbill_create_ip: remote_ip,
      notify_url: notify_url,
      trade_type: 'NATIVE' # could be "JSAPI" or "NATIVE",
    }
    res = WxPay::Service.invoke_unifiedorder params
    return res['code_url']
  end

  # 返回一个支付宝对象
  def get_alipay_client
    client = Alipay::Client.new(
      url: 'https://openapi.alipaydev.com/gateway.do',
      app_id: Settings.alipay_app_id,
      app_private_key: Settings.alipay_app_private_key,
      alipay_public_key: Settings.alipay_public_key
    )
    client
  end

  # 得到一个支付宝链接 type: {wap|page}
  def get_alipay_prepay_url(type='wap')
    require 'alipay'
    notify_url = Settings.app_host + "/payment/alipay_payments/notify"
    quit_url = Settings.app_host + '/m/'

    method = "alipay.trade.#{type}.pay"

    @client = get_alipay_client
    url = @client.page_execute_url(
      method: method,
      return_url: quit_url,
      notify_url: notify_url,
      biz_content: {
       out_trade_no: self.order_no,
       product_code: 'QUICK_WAP_WAY',
       total_amount: '0.01',
       subject: 'Example: 456',
       quit_url: quit_url
      }.to_json
    )
  end

end
