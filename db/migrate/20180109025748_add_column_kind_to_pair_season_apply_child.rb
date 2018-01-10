class AddColumnKindToPairSeasonApplyChild < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_children, :kind, :integer, comment: '捐助形式：1对外捐助 2内部认捐'
  end
end
