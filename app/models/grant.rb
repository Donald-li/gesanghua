# == Schema Information
#
# Table name: grants # 发放表
#
#  id                      :integer          not null, primary key
#  project_id              :integer                                # 归属项目ID
#  project_season_id       :integer                                # 项目年度ID
#  school_id               :integer                                # 学校ID
#  project_season_apply_id :integer                                # 项目申请ID
#  gsh_child_id            :integer                                # 格桑花孩子ID
#  grant_no                :string                                 # 发放编号
#  state                   :integer                                # 状态
#  amount                  :decimal(14, 2)   default(0.0)          # 资助金额
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  grant_batch_id          :integer                                # 批次号
#

#TODO: 已废弃
class Grant < ApplicationRecord

  belongs_to :project
  belongs_to :project_season
  belongs_to :school
  belongs_to :gsh_child
  belongs_to :grant_batch, optional: true
  belongs_to :project_season_apply, optional: true

  has_many :remarks, as: :onwer

  enum state: {waiting: 1, granted: 2, suspend: 3, cancel: 4}
  default_value_for :state, 1

  scope :sorted, ->{ order(created_at: :desc) }

end
