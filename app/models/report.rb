# == Schema Information
#
# Table name: reports # 报告表
#
#  id         :integer          not null, primary key
#  title      :string                                 # 标题
#  content    :text                                   # 内容
#  owner_type :string
#  owner_id   :integer
#  type       :string                                 # 单表：audit_report、financial_report、project_report
#  state      :integer                                # 状态
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Report < ApplicationRecord

  validates :title, :content, presence: true

  scope :sorted, ->{ order(created_at: :desc) }

  enum state: {show: 1, hidden: 2} # 状态 1:显示 2:隐藏
  default_value_for :state, 1

  include HasAsset
  has_many_assets :report_files, class_name: 'Asset::ReportFile'

end
