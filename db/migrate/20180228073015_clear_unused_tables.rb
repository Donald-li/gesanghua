class ClearUnusedTables < ActiveRecord::Migration[5.1]
  def change
    drop_table :grants
    drop_table :gsh_children
    drop_table :child_periods
    drop_table :child_trails
    drop_table :donation_use_logs
    drop_table :project_season_courses
    drop_table :radio_informations
  end
end
