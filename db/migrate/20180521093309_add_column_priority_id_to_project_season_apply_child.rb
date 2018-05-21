class AddColumnPriorityIdToProjectSeasonApplyChild < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_children, :priority_id, :integer, comment: '优先捐助人id'
  end
end
