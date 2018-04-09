class AddColumnExecuteStateToCampaigns < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :execute_state, :integer, comment: '执行状态'
  end
end
