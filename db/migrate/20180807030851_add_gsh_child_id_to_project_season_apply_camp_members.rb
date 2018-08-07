class AddGshChildIdToProjectSeasonApplyCampMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_camp_members, :gsh_child_id, :integer
  end
end
