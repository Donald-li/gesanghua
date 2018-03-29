# == Schema Information
#
# Table name: camp_document_estimates # 拓展营概算表
#
#  id                      :integer          not null, primary key
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
  belongs_to :apply, class_name: 'ProjectSeasonApply'
  belongs_to :user
  belongs_to :camp

  validates :item, presence: true
  validates :amount, numericality: {greater_than_or_equal_to: 0}

  scope :sorted, ->{order(id: :asc)}
  scope :in_apply, ->(apply){where(apply: apply)}

end
