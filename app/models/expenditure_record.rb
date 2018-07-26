# == Schema Information
#
# Table name: expenditure_records # 支出记录表
#
#  id                    :bigint(8)        not null, primary key
#  fund_id               :integer                                # 基金ID
#  appoint_type          :string                                 # 指定类型
#  appoint_id            :integer                                # 指定类型id
#  administrator_id      :integer                                # 管理员id
#  income_record_id      :integer                                # 入账记录id
#  deliver_state         :integer                                # 发放状态
#  kind                  :integer                                # 类别
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  name                  :string                                 # 支出名称
#  expend_no             :string                                 # 支出编号
#  expended_at           :datetime                               # 支出时间
#  operator              :string                                 # 支出经办人
#  remark                :text                                   # 备注
#  amount                :decimal(14, 2)   default(0.0)          # 支出金额
#  expenditure_ledger_id :integer
#  income_source_id      :integer
#

# 支出记录
class ExpenditureRecord < ApplicationRecord

  has_paper_trail only: [:fund_id, :administrator_id, :income_record_id, :kind, :name, :expend_no, :expended_at, :operator, :remark, :amount, :income_source_id]

  include HasAsset
  has_many_assets :images, class_name: 'Asset::ExpenditureRecordImage'
  has_one_asset :expenditure_record_excel, class_name: 'Asset::ExpenditureRecordExcel'

  belongs_to :fund
  belongs_to :income_source
  belongs_to :administrator, optional: true
  belongs_to :income_record, optional: true
  # appoint_type 多态关联
  # belongs_to :user, polymorphic: true

  # enum deliver_state: {to_deliver: 1, deliver: 2} # 发放状态，1:待发放 2:已发放
  # default_value_for :deliver_state, 1
  # enum kind: {}
  # counter_culture :expenditure_ledger, column_name: 'amount', delta_magnitude: proc {|model| model.amount }
  counter_culture :fund, column_name: proc {|model|model.expended_at >= Time.mktime(2018,6,1) ? 'out_total' : 0  }, delta_column: 'amount'
  counter_culture :income_source, column_name: proc {|model| model.expended_at >= Time.mktime(2018,6,1) ? 'out_total' : nil} , delta_column: 'amount'

  before_create :gen_expend_no

  scope :sorted, ->{ order(created_at: :desc) }
  scope :can_count, ->{where("expended_at >= ?", Time.mktime(2018,6,1))}

  def self.download_path
    "/excel/expenditure/支出记录导入模板文件.xlsx"
  end

  def self.download_name
    '支出记录导入模板文件.xlsx'
  end

  def self.read_excel(excel_id)
    file = Asset.find(excel_id).try(:file).try(:file)
    FileUtil.import_expenditure_records(original_filename: file.original_filename, path: file.path) if file.present?
  end

  def secure_operator
    return unless self.present?
    return '' if self.operator.blank?
    if self.operator.length < 2
      self.operator
    else
      self.operator.sub(self.operator[1,1], '*')
    end
  end

  def self.update_expenditure_statistic_record
    group_records = self.where("created_at >= ? and created_at <= ?", Time.now.beginning_of_day, Time.now.end_of_day)
    if group_records.count > 0
      self.gen_expenditure_finance_statistic_record(group_records)
    # else
    #   StatisticRecord.find_or_create_by(kind: 4, record_time: Time.now.strftime("%Y-%m-%d"), amount: 0)
    end

  end

  def self.update_expenditure_history_records
    group_records = self.all
    if group_records.count > 0
      self.gen_expenditure_finance_statistic_record(group_records)
    else
      StatisticRecord.find_or_create_by(kind: 4, record_time: Time.now.strftime("%Y-%m-%d"), amount: 0)
    end
  end

  def self.gen_expenditure_finance_statistic_record(finance_records)
    group_records = finance_records.where("expended_at >= ?", Time.mktime(2018,6,1)).group_by {|record| record.expended_at.strftime("%Y-%m-%d")}
    group_records.each do |record_time, records|
      # 按照财务分类统计
      records.group_by(&:fund_id).each do |fund_id, fund_records|
        amount = 0
        if fund_id.present?
          fund = Fund.find(fund_id)
          fund_records.each {|fund_record| amount += fund_record.amount}
          f_record = StatisticRecord.find_or_create_by(kind: 4, record_time: record_time, owner: fund)
          f_record.update(amount: amount)
        end
      end

      # 按照账户统计
      records.group_by(&:income_source_id).each do |source_id, source_records|
        amount = 0
        if source_id.present?
          source = IncomeSource.find(source_id)
          source_records.each {|source_record| amount += source_record.amount}
          f_record = StatisticRecord.find_or_create_by(kind: 4, record_time: record_time, owner: source)
          f_record.update(amount: amount)
        end
      end
    end
  end

  private
  def gen_expend_no
    time_string = Time.now.strftime("%y%m%d%H")
    self.expend_no ||= Sequence.get_seq(kind: :expend_no, prefix: "Z#{time_string}", length: 7)
  end
end
