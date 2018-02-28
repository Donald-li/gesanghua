# == Schema Information
#
# Table name: project_season_apply_volunteers # 项目执行年度申请和志愿者关联表
#
#  id                      :integer          not null, primary key
#  project_id              :integer                                # 关联项目id
#  project_season_id       :integer                                # 关联项目执行年度id
#  project_season_apply_id :integer                                # 关联项目执行年度的申请id
#  volunteer_id            :integer                                # 关联志愿者id
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

# 项目年度申请和志愿者关系表（如家访等）
class ProjectSeasonApplyVolunteer < ApplicationRecord
  belongs_to :project
  belongs_to :project_season
  belongs_to :project_season_apply
  belongs_to :volunteer
end
