# == Schema Information
#
# Table name: teacher_projects # 老师项目表
#
#  id         :bigint(8)        not null, primary key
#  teacher_id :integer                                # 老师id
#  project_id :integer                                # 项目id
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe TeacherProject, type: :model do
  
end
