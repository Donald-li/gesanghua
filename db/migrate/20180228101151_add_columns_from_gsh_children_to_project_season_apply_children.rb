class AddColumnsFromGshChildrenToProjectSeasonApplyChildren < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_children, :gsh_no, :string, comment: '格桑花孩子编号'
    add_column :project_season_apply_children, :semester_count, :integer, comment: '学期数'
    add_column :project_season_apply_children, :done_semester_count, :integer, comment: '已完成的学期数'
    add_column :project_season_apply_children, :user_id, :integer, comment: '关联的用户ID'
  end
end
