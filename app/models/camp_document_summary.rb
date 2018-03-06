# == Schema Information
#
# Table name: camp_document_summaries # 拓展营总结
#
#  id                :integer          not null, primary key
#  project_season_id :integer                                # 项目
#  user_id           :integer                                # 用户
#  free_resource     :string                                 # 本营免费资源
#  resource_value    :decimal(14, 2)   default(0.0)          # 免费资源价值
#  donate_amount     :decimal(14, 2)   default(0.0)          # 本营筹款多少
#  publicize_count   :integer                                # 本营宣传次数
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class CampDocumentSummary < ApplicationRecord
  include HasAsset
  has_one_asset :report, class_name: 'Asset::ReportFile'

  belongs_to :project_season
  belongs_to :user

  validates :free_resource, :donate_amount, presence: true
  validates :resource_value, numericality: {greater_than_or_equal_to: 0}
  validates :donate_amount, numericality: {greater_than_or_equal_to: 0}

  scope :sorted, ->{order(id: :asc)}
  scope :in_season, ->(project_season){where(project_season: project_season)}

end
