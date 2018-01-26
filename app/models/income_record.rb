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
#  donate_record_id :integer                                # 捐助记录id
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  income_time      :datetime                               # 入账时间
#  remark           :text                                   # 备注
#

class IncomeRecord < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :fund, optional: true
  belongs_to :income_source, optional: true
  belongs_to :promoter, class_name: 'User', optional: true
  # belongs_to :remitter, class_name: 'User'

  has_many :expenditure_records
  belongs_to :donate_record, optional: true
  # appoint_type 多态关联
  # belongs_to :user, polymorphic: true

  validates :amount, :donor, :income_time, presence: true

  include HasAsset
  has_one_asset :income_record_excel, class_name: 'Asset::IncomeRecordExcel'

  # enum state: {}

  scope :sorted, ->{ order(created_at: :desc) }

  counter_culture :user, column_name: 'donate_count', delta_magnitude: proc {|model| model.amount}
  counter_culture :user, column_name: proc {|model| model.income_source.present? && model.income_source.online? ? 'online_count' : nil }, delta_magnitude: proc {|model| model.amount}
  counter_culture :user, column_name: proc {|model| model.income_source.present? && model.income_source.offline? ? 'offline_count' : nil }, delta_magnitude: proc {|model| model.amount}

  def self.read_excel(excel_id)
  file = Asset.find(excel_id).try(:file).try(:file)
  FileUtil.import_income_records(original_filename: file.original_filename, path: file.path) if file.present?
  end

  def self.update_income_statistic_record
    record_times = self.where("created_at > ? and created_at < ?", Time.now.beginning_of_day, Time.now.end_of_day).group_by{|record| record.income_time.strftime("%Y-%m-%d")}.keys
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

end
