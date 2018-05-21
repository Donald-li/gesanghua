class AddColumnClassnameToProjectSeasonApplyChildren < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_children, :classname, :string, comment: '班级名称'
  end
end
