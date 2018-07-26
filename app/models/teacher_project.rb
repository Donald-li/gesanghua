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

# 教师项目关系表
class TeacherProject < ApplicationRecord
  belongs_to :teacher
  belongs_to :project

  scope :sorted, ->{ order(created_at: :desc) }
end
