# == Schema Information
#
# Table name: income_records # 入帐记录表
#
#  id               :integer          not null, primary key
#  donor_id         :integer                                # 用户id
#  fund_id          :integer                                # 基金ID
#  income_source_id :integer                                # 来源id
#  amount           :decimal(14, 2)   default(0.0)          # 入账金额
#  balance          :decimal(14, 2)   default(0.0)          # 余额
#  agent_id         :integer                                # 汇款人id
#  promoter_id      :integer                                # 劝捐人
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  income_time      :datetime                               # 入账时间
#  remark           :text                                   # 备注
#  voucher_state    :integer                                # 开票状态
#  title            :string                                 # 收入名称
#  donation_id      :integer                                # 捐助id
#  kind             :integer                                # 来源: 1:线上 2:线下
#  team_id          :integer                                # 团队id
#  voucher_id       :integer                                # 捐赠收据ID
#  certificate_no   :string                                 # 捐赠证书编号
#  income_no        :string                                 # 收入编号
#

# 收入记录
# 我的捐款，开具发票，款均使用收入记录
class IncomeRecord < ApplicationRecord
  belongs_to :donation, optional: true

  belongs_to :donor, class_name: 'User', foreign_key: 'donor_id', optional: true
  belongs_to :agent, class_name: 'User', foreign_key: 'agent_id', optional: true
  belongs_to :promoter, class_name: 'User', foreign_key: 'promoter_id', optional: true
  belongs_to :voucher, optional: true
  has_one :account_records

  has_many :donate_records, dependent: :nullify

  belongs_to :fund, optional: true
  belongs_to :income_source, optional: true

  validates :amount, :income_time, presence: true

  enum kind: {online: 1, offline: 2} #分类: 线上、线下
  default_value_for :kind, 1

  enum voucher_state: {to_bill: 1, billed: 2} #收据状态，1:未开票 2:已开票
  default_value_for :voucher_state, 1

  before_create :gen_income_no

  include HasAsset
  has_one_asset :income_record_excel, class_name: 'Asset::IncomeRecordExcel'

  scope :sorted, -> {order(created_at: :desc)}
  scope :has_balance, -> {where('income_records.balance > 0')}

  # 可开票记录
  scope :open_ticket, -> {to_bill.where(created_at: (Time.now.beginning_of_year)..(Time.now.end_of_year))}

  counter_culture :agent, column_name: proc {|model| model.income_source.present? && !model.income_source.offline? ? 'online_amount' : nil}, delta_magnitude: proc {|model| model.amount}
  counter_culture :agent, column_name: proc {|model| model.income_source.present? && model.income_source.offline? ? 'offline_amount' : nil}, delta_magnitude: proc {|model| model.amount}
  counter_culture :agent, column_name: 'donate_amount', delta_magnitude: proc {|model| model.amount}
  counter_culture :fund, column_name: 'balance', delta_magnitude: proc {|model| model.amount}
  counter_culture :fund, column_name: 'total', delta_magnitude: proc {|model| model.amount}

  before_create :gen_certificate_no

  def has_balance?
    self.balance > 0
  end

  # 微信入账记录
  def self.wechat_record(agent, amount)
    IncomeRecord.new(agent: agent, amount: amount, balance: amount, voucher_state: 'to_bill', income_source_id: 1, income_time: Time.now)
  end

  def self.read_excel(excel_id)
    file = Asset.find(excel_id).try(:file).try(:file)
    FileUtil.import_income_records(original_filename: file.original_filename, path: file.path) if file.present?
  end

  def self.update_income_statistic_record
    record_times = self.where("created_at > ? and created_at < ?", Time.now.beginning_of_day, Time.now.end_of_day).group_by {|record| record.income_time.strftime("%Y-%m-%d")}.keys
    if record_times.size > 0
      record_times.each do |record_time|
        record_time = Time.parse(record_time)
        amount = self.where("income_time > ? and income_time < ?", record_time.beginning_of_day, record_time.end_of_day).sum(:amount)
        record = StatisticRecord.find_or_create_by(kind: 2, record_time: record_time)
        record.update(amount: amount)
      end
    else
      StatisticRecord.create(kind: 2, record_time: Time.now.strftime("%Y-%m-%d"), amount: 0)
    end
  end

  # 总计捐助金额
  def self.total_amount
    self.sum(:amount).to_f
  end

  # 生成捐赠编号
  def gen_certificate_no
    self.agent_id ||= self.donor_id
    time_string = Time.now.strftime("%y%m%d%H")
    self.certificate_no ||= Sequence.get_seq(kind: :certificate_no, prefix: "ZS#{time_string}", length: 7)
  end

  #捐赠证书路径
  def donor_certificate_path
    self.certificate_no ||= Sequence.get_seq(kind: :certificate_no, prefix: "ZS#{time_string}", length: 7)
    path = "/images/certificates/#{self.created_at.strftime('%Y%m%d')}/#{self.id}/#{Encryption.md5(self.certificate_no.to_s)}.jpg"
    local_path = Rails.root.to_s + '/public' + path
    if !File::exist?(local_path)
      GenDonateCertificate.create(self)
    end
    self.save
    path
  end

  # 是否可开票
  def open_ticket?
    self.to_bill? && self.created_at.between?(Time.now.beginning_of_year, Time.now.end_of_year)
  end

  # 计算开票金额
  def self.count_amount(ids)
    donates = IncomeRecord.find(ids)
    if donates.present?
      amount = donates.sum {|d| d.amount.to_f}
      return amount
    else
      return 0
    end
  end

  # 入账记录的描述
  def title
    if self.offline?
      self.attributes['title']
    else
      self.donation.try(:title)
    end
  end

  # 代捐人名称
  def agent_name
    return '无' if self.agent.blank?
    self.agent_id == self.donor_id ? '无' : self.agent.try(:show_name)
  end

  # 捐赠证书中用到的项目名称
  def project_name
    self.donation.try(:project).try(:name)
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :kind, :certificate_no)
      json.title self.title
      json.donor self.donor.try(:show_name)
      json.agent self.agent_name
      json.time self.created_at
      json.amount self.amount
      json.donate_tag self.donor_id === self.agent_id ? '' : '代捐'
      json.project_info_route self.project_info_route
    end.attributes!
  end

  def project_info_route
    return false unless self.donation.present?
    donation = self.donation
    case donation.owner_type
      when 'DonateItem'
        if donation.owner.project.present?
          if donation.owner.project == Project.read_project
            {name: 'project-description', query: {name: 'read'}}
          elsif donation.owner.project == Project.camp_project
            {name: 'project-description', query: {name: 'camp'}}
          elsif donation.owner.project == Project.pair_project
            {name: 'project-description', query: {name: 'pair'}}
          elsif donation.owner.project.goods?
            {name: 'project-description', query: {name: donation.owner.project.id}}
          end
        else
          ''
        end
      when 'ProjectSeasonApply'
        if donation.owner.project == Project.read_project
          if donation.owner.whole?
            {name: 'read', params: {id: donation.owner_id.to_s}}
          else
            {name: 'read-supplement', params: {id: donation.owner_id.to_s}}
          end
        elsif donation.owner.project == Project.camp_project
          {name: 'camp', params: {id: donation.owner_id.to_s}}
        elsif donation.owner.project.goods?
          {name: 'goods', params: {id: donation.owner_id.to_s}}
        end
      when 'ProjectSeasonApplyBookshelf'
        {name: 'read', params: {id: donation.owner_id.to_s}}
      when 'ProjectSeasonApplyChild'
        {name: 'pair', params: {id: donation.owner_id.to_s}}
      when 'CampaignEnlist'
        {name: 'campaign', params: {id: donation.owner.campaign.id.to_s}}
    end
  end

  def certificate_builder
    Jbuilder.new do |json|
      json.(self, :certificate_no)
      json.certificate self.donor_certificate_path
    end.attributes!
  end

  private
  def gen_income_no
    time_string = Time.now.strftime("%y%m%d%H")
    self.income_no ||= Sequence.get_seq(kind: :income_no, prefix: time_string, length: 7)
  end
end
