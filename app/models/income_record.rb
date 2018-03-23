# == Schema Information
#
# Table name: income_records # 入帐记录表
#
#  id               :integer          not null, primary key
#  user_id          :integer                                # 用户id
#  fund_id          :integer                                # 基金ID
#  appoint_type     :string                                 # 指定类型
#  appoint_id       :integer                                # 指定类型id
#  state            :integer                                # 状态
#  income_source_id :integer                                # 来源id
#  amount           :decimal(14, 2)   default(0.0)          # 入账金额
#  balance          :decimal(14, 2)   default(0.0)          # 余额
#  remitter_name    :string                                 # 汇款人姓名
#  remitter_id      :integer                                # 汇款人id
#  donor            :string                                 # 捐赠者
#  promoter_id      :integer                                # 劝捐人
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  income_time      :datetime                               # 入账时间
#  remark           :text                                   # 备注
#  voucher_state    :integer                                # 开票状态
#  title            :string                                 # 收入名称
#

# 收入记录
class IncomeRecord < ApplicationRecord

  before_create :set_record_title

  belongs_to :user, optional: true
  belongs_to :fund, optional: true
  belongs_to :income_source, optional: true
  belongs_to :promoter, class_name: 'User', optional: true
  # belongs_to :remitter, class_name: 'User'

  has_many :expenditure_records
  has_many :donate_records, dependent: :nullify
  # appoint_type 多态关联
  # belongs_to :user, polymorphic: true

  validates :amount, :income_time, presence: true

  enum voucher_state: {to_bill: 1, billed: 2} #收据状态，1:未开票 2:已开票
  default_value_for :voucher_state, 1

  include HasAsset
  has_one_asset :income_record_excel, class_name: 'Asset::IncomeRecordExcel'

  # enum state: {}

  scope :sorted, -> {order(created_at: :desc)}
  scope :has_balance, ->{where('income_records.balance > 0')}

  counter_culture :user, column_name: proc {|model| model.income_source.present? && model.income_source.online? ? 'online_count' : nil}, delta_magnitude: proc {|model| model.amount}
  counter_culture :user, column_name: proc {|model| model.income_source.present? && model.income_source.offline? ? 'offline_count' : nil}, delta_magnitude: proc {|model| model.amount}

  def has_balance?
    self.balance > 0
  end

  # 微信入账
  def self.wechat_payment(result, params)
    donate_record = DonateRecord.find_by(donate_no: result['out_trade_no'])
    income_record = self.wechat_record(donate_record.user, result['total_fee'])
    donate_record.update(pay_state: 'paid', income_record: income_record, pay_result: result.to_json) if donate_record.unpay?
    DonateRecord.use_income_record_donate_apply(income_record.reload) if donate_record.project_id == 2 # 处理悦读申请捐款
  end

  # 微信入账记录
  def self.wechat_record(user, amount)
    IncomeRecord.new(user: user, amount: amount, balance: amount, voucher_state: 'to_bill', income_source_id: 1, income_time: Time.now)
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

  def set_record_title
    return if self.title.present?
    donate_record = self.donate_records.first
    return unless donate_record
    self.title ||= "#{donate_record.try(:user).try(:name)}捐助#{donate_record.try(:donate_item).try(:name)}#{self.try(:donate_item).try(:fund).try(:name)}款项"
  end

end
