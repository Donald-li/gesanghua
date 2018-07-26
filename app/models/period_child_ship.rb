# == Schema Information
#
# Table name: period_child_ships # 年度孩子和申请学期中间表
#
#  id                             :bigint(8)        not null, primary key
#  project_season_apply_period_id :integer                                # 申请学期ID
#  project_season_apply_child_id  :integer                                # 年度孩子ID
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#

# 结对孩子与学期的中间表
class PeriodChildShip < ApplicationRecord
  belongs_to :project_season_apply_period
  belongs_to :project_season_apply_child
end
