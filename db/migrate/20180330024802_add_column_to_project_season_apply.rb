class AddColumnToProjectSeasonApply < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_applies, :camp_start_time, :datetime, comment: '探索营-开营时间'
    add_column :project_season_applies, :camp_period, :integer, comment: '探索营-行程天数'
    add_column :project_season_applies, :camp_state, :integer, comment: '探索营-项目状态'
    add_column :project_season_applies, :camp_principal, :string, comment: '探索营-营负责人'
    add_column :project_season_applies, :camp_income_source, :string, comment: '探索营-经费来源'
  end
end
