class AddColumnRemarkToProjectSeasonApplyChild < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_children, :remark, :text, comment: '备注'
  end
end
