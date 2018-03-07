class AddColumnJoinTeamTimeToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :join_team_time, :datetime, comment: '加入团队时间'
  end
end
