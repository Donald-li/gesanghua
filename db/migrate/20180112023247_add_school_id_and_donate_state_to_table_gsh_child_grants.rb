class AddSchoolIdAndDonateStateToTableGshChildGrants < ActiveRecord::Migration[5.1]
  def change
    add_column :gsh_child_grants, :school_id, :integer, comment: '学校ID'
    add_column :gsh_child_grants, :project_season_id, :integer, comment: '批次ID'
    add_column :gsh_child_grants, :donate_state, :integer, comment: '捐助状态'
  end
end
