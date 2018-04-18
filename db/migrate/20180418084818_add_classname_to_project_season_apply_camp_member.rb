class AddClassnameToProjectSeasonApplyCampMember < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_camp_members, :classname, :string, comment: '年级'
  end
end
