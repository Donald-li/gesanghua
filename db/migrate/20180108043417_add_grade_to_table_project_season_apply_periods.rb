class AddGradeToTableProjectSeasonApplyPeriods < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_periods, :grade, :integer, comment: '结对对应年级'
    add_column :project_season_apply_periods, :semester, :integer, comment: '结对对应学期'
    add_column :project_season_apply_children, :semester, :integer, comment: '学期'
  end
end
