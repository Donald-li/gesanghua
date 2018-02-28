class AddColumnDonateUserIdToProjectSeasonApplyChild < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_children, :donate_user_id, :integer, comment: '捐助人id'
  end
end
