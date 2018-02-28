# == Schema Information
#
# Table name: project_season_goods # 物资类项目，执行年度的物品表
#
#  id                :integer          not null, primary key
#  project_id        :integer                                # 关联项目id
#  project_season_id :integer                                # 关联执行年度id
#  name              :string                                 # 物品名称
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

# 设置年度可申请的物品
class ProjectSeasonGoods < ApplicationRecord
  belongs_to :project
  belongs_to :project_season, optional: true

  validates :name, presence: true


end
