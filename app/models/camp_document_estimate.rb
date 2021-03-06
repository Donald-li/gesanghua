# == Schema Information
#
# Table name: camp_document_estimates # 拓展营概算表
#
#  id                      :bigint(8)        not null, primary key
#  user_id                 :integer                                # 用户
#  item                    :string                                 # 项
#  amount                  :decimal(14, 2)   default(0.0)          # 金额
#  remark                  :string                                 # 备注
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  project_season_apply_id :integer                                # 探索营申请id
#  camp_id                 :integer                                # 探索营id
#

class CampDocumentEstimate < ApplicationRecord
  has_paper_trail only: [:item, :amount, :remark, :project_season_apply_id, :camp_id]

  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: :project_season_apply_id
  belongs_to :user
  belongs_to :camp

  validates :item, presence: true
  validates :amount, numericality: {greater_than_or_equal_to: 0}

  scope :sorted, ->{order(id: :asc)}
  scope :in_apply, ->(apply){where(apply: apply)}

  #用于操作日志查找关系
  def project_season_apply
    self.apply
  end
end
