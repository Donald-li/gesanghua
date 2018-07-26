class AddColumnStudentStateToProjectSeasonApplyChildren < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_children, :student_state, :integer, default: 0, comment: '学生状态'
  end
end
