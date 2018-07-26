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

FactoryBot.define do
  factory :period_child_ship do
    project_season_apply_period_id 1
    project_season_apply_child_id 1
  end
end
