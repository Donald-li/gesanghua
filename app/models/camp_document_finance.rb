# == Schema Information
#
# Table name: camp_document_finances # 拓展营预决算表
#
#  id                :integer          not null, primary key
#  project_season_id :integer                                # 项目
#  user_id           :integer                                # 用户
#  item              :string                                 # 项
#  budge             :decimal(14, 2)   default(0.0)          # 预算
#  amount            :decimal(14, 2)   default(0.0)          # 决算
#  remark            :string                                 # 备注
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class CampDocumentFinance < ApplicationRecord
  belongs_to :project_season
  belongs_to :user

  validates :item, presence: true
  validates :budge, numericality: {greater_than_or_equal_to: 0}
  validates :amount, numericality: {greater_than_or_equal_to: 0, allow_blank: true}

  scope :sorted, ->{order(id: :asc)}
  scope :in_season, ->(project_season){where(project_season: project_season)}
end
