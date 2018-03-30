# == Schema Information
#
# Table name: camp_document_finances # 拓展营预决算表
#
#  id                      :integer          not null, primary key
#  user_id                 :integer                                # 用户
#  item                    :string                                 # 项
#  budge                   :decimal(14, 2)   default(0.0)          # 预算
#  amount                  :decimal(14, 2)   default(0.0)          # 决算
#  remark                  :string                                 # 备注
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  project_season_apply_id :integer                                # 探索营申请id
#  camp_id                 :integer                                # 探索营id
#

class CampDocumentFinance < ApplicationRecord
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: :project_season_apply_id
  belongs_to :user
  belongs_to :camp

  validates :item, presence: true
  validates :budge, numericality: {greater_than_or_equal_to: 0}
  validates :amount, numericality: {greater_than_or_equal_to: 0, allow_blank: true}

  scope :sorted, ->{order(id: :asc)}
  scope :in_apply, ->(apply){where(apply: apply)}
end
