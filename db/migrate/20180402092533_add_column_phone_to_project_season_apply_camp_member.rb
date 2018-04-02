class AddColumnPhoneToProjectSeasonApplyCampMember < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_camp_members, :phone, :string, comment: '联系方式（老师角色）'
  end
end
