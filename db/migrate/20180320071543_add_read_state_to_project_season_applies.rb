class AddReadStateToProjectSeasonApplies < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_applies, :read_state, :integer, comment: '悦读项目状态'
  end
end
