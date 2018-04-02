class AddColumnTeacherIdToProjectSeasonApplyCamp < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_camps, :teacher_id, :integer, comment: '联系老师id'
  end
end
