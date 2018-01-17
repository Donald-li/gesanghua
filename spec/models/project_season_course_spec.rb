# == Schema Information
#
# Table name: project_season_courses # 项目执行年度的课程表(例：护花)
#
#  id                :integer          not null, primary key
#  project_id        :integer                                # 关联项目id
#  project_season_id :integer                                # 关联项目执行年度id
#  name              :string                                 # 课程名称
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe ProjectSeasonCourse, type: :model do
  
end
