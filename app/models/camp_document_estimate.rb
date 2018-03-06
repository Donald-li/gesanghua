# == Schema Information
#
# Table name: camp_document_estimates # 拓展营概算表
#
#  id                :integer          not null, primary key
#  project_season_id :integer                                # 项目
#  user_id           :integer                                # 用户
#  item              :string                                 # 项
#  amount            :decimal(14, 2)   default(0.0)          # 金额
#  remark            :string                                 # 备注
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class CampDocumentEstimate < ApplicationRecord
  belongs_to :project_season
  belongs_to :user

  validates :item, presence: true
  validates :amount, numericality: {greater_than_or_equal_to: 0}

  scope :sorted, ->{order(id: :asc)}
  scope :in_season, ->(project_season){where(project_season: project_season)}

end
