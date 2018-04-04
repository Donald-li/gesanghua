class AddDetailsToDonations < ActiveRecord::Migration[5.1]
  def change
    add_column :donations, :details, :jsonb, comment: '捐助详情'
    remove_column :donations, :project_season_apply_child_id
    add_column :income_records, :team_id, :integer, comment: '团队id'
    remove_column :donate_records, :project_season_apply_child_id
    remove_column :donate_records, :donate_item_id
  end
end
