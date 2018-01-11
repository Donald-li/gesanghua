# == Schema Information
#
# Table name: teacher_projects # 老师项目表
#
#  id         :integer          not null, primary key
#  teacher_id :integer                                # 老师id
#  project_id :integer                                # 项目id
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe TeacherProject, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
