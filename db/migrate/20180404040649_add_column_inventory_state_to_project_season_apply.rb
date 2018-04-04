class AddColumnInventoryStateToProjectSeasonApply < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_applies, :inventory_state, :integer, comment: '是否使用物资清单'
  end
end
