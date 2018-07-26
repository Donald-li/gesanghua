# == Schema Information
#
# Table name: camp_document_summaries # 拓展营总结
#
#  id                      :bigint(8)        not null, primary key
#  user_id                 :integer                                # 用户
#  free_resource           :string                                 # 本营免费资源
#  resource_value          :decimal(14, 2)   default(0.0)          # 免费资源价值
#  donate_amount           :decimal(14, 2)   default(0.0)          # 本营筹款多少
#  publicize_count         :integer                                # 本营宣传次数
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  project_season_apply_id :integer                                # 探索营申请id
#  camp_id                 :integer                                # 探索营id
#

class CampDocumentSummary < ApplicationRecord
  has_paper_trail only: [:user_id, :free_resource, :resource_value, :donate_amount, :publicize_count, :project_season_apply_id, :camp_id]

  include HasAsset
  has_one_asset :report, class_name: 'Asset::ReportFile'

  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: :project_season_apply_id
  belongs_to :user
  belongs_to :camp

  validates :free_resource, :donate_amount, presence: true
  validates :resource_value, numericality: {greater_than_or_equal_to: 0}
  validates :donate_amount, numericality: {greater_than_or_equal_to: 0}

  scope :sorted, ->{order(id: :asc)}
  scope :in_apply, ->(apply){where(apply: apply)}

  #用于操作日志查找关系
  def project_season_apply
    self.apply
  end
  
end
