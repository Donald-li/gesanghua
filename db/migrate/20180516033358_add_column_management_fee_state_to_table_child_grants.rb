class AddColumnManagementFeeStateToTableChildGrants < ActiveRecord::Migration[5.1]
  def change
    remove_column :project_season_apply_children, :management_fee_state, :integer, comment: '计提管理费状态'
    add_column :gsh_child_grants, :management_fee_state, :integer, comment: '计提管理费状态'

    GshChildGrant.update_all(management_fee_state: 0)
  end
end
