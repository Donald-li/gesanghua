# == Schema Information
#
# Table name: reports # 报告表
#
#  id           :bigint(8)        not null, primary key
#  title        :string                                 # 标题
#  content      :text                                   # 内容
#  type         :string                                 # 单表：audit_report、financial_report、project_report
#  state        :integer                                # 状态
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  project_id   :integer                                # 项目ID
#  published_at :datetime                               # 发布时间
#  position     :integer                                # 位置
#  user_id      :integer                                # 发布人
#

# 报告类的父表
class Report < ApplicationRecord

  validates :title, :content, presence: true

  belongs_to :user, optional: true
  
  scope :sorted, ->{ order(created_at: :desc) }

  enum state: {show: 1, hidden: 2} # 状态 1:显示 2:隐藏
  default_value_for :state, 1

  include HasAsset
  has_many_assets :report_files, class_name: 'Asset::ReportFile'
  has_many_assets :images, class_name: 'Asset::ReportImage'

end
