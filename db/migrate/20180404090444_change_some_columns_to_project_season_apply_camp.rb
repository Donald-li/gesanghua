class ChangeSomeColumnsToProjectSeasonApplyCamp < ActiveRecord::Migration[5.1]
  def change
    remove_column :project_season_apply_camps, :teacher_id, :integer
    add_column :project_season_apply_camps, :contact_name, :string
    add_column :project_season_apply_camps, :contact_phone, :string
  end
end
