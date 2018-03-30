class ChangeColumnStateToExecuteStateToprojectSrasonApplyCamp < ActiveRecord::Migration[5.1]
  def change
    remove_column :project_season_apply_camps, :state, :integer
    add_column :project_season_apply_camps, :execute_state, :integer
  end
end
