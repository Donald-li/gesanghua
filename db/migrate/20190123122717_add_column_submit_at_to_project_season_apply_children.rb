class AddColumnSubmitAtToProjectSeasonApplyChildren < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_children, :submit_at, :datetime
  end
end
