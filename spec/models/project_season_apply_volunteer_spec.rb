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

require 'rails_helper'

RSpec.describe ProjectSeasonApplyVolunteer, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
