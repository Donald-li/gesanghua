class AddColumnTeacherIdToProjectSeasonApplyCamp < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_camps, :teacher_id, :integer, comment: '联系老师id'
    add_column :project_season_apply_camp_students, :age, :integer, comment: '年龄'
    add_column :project_season_apply_camp_teachers, :age, :integer, comment: '年龄'
  end
end
