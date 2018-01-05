class AddPostionAndProjectSeasonIdTableProjectSeasonApplyPeriods < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_periods, :project_season_id, :integer, comment: '年度ID'
    add_column :project_season_apply_periods, :position, :integer, comment: '位置'
  end
end
