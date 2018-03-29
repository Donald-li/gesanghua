class AddColumnProjectApplyChildIdToGshChildGrants < ActiveRecord::Migration[5.1]
  def change
    add_column :gsh_child_grants, :project_season_apply_child_id, :integer, comment: '一对一助学孩子id'
  end
end
