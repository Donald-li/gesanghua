class AddPairStateToProjectSeasonApplies < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_applies, :pair_state, :integer, comment: '结对审核状态'
  end
end
