# == Schema Information
#
# Table name: expenditure_records # 支出记录表
#
#  id               :integer          not null, primary key
#  fund_id          :integer                                # 基金ID
#  appoint_type     :string                                 # 指定类型
#  appoint_id       :integer                                # 指定类型id
#  administrator_id :integer                                # 管理员id
#  income_record_id :integer                                # 入账记录id
#  deliver_state    :integer                                # 发放状态
#  kind             :integer                                # 类别
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  name             :string                                 # 支出名称
#  expend_no        :string                                 # 支出编号
#  expended_at      :datetime                               # 支出时间
#  operator         :string                                 # 支出经办人
#  remark           :text                                   # 备注
#  amount           :decimal(14, 2)   default(0.0)          # 支出金额
#

# 支出记录
class ExpenditureRecord < ApplicationRecord
  include HasAsset
  has_many_assets :images, class_name: 'Asset::ExpenditureRecordImage'
  has_one_asset :expenditure_record_excel, class_name: 'Asset::ExpenditureRecordExcel'

  belongs_to :fund
  belongs_to :administrator, optional: true
  belongs_to :income_record, optional: true
  # appoint_type 多态关联
  # belongs_to :user, polymorphic: true

  # enum deliver_state: {to_deliver: 1, deliver: 2} # 发放状态，1:待发放 2:已发放
  # default_value_for :deliver_state, 1
  # enum kind: {}

  scope :sorted, ->{ order(created_at: :desc) }

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
end
