class AddColumnTaskStateToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :volunteers, :task_state, :boolean, default: false, comment: '志愿者是否有未查看的指派任务'
    add_column :users, :notice_state, :boolean, default: false, comment: '用户是否有未查看的公告'
  end
end
