class AddColumnToTaskVolunteer < ActiveRecord::Migration[5.1]
  def change
    add_column :task_volunteers, :user_id, :integer, comment: '审核人id'
    add_column :task_volunteers, :finish_state, :integer, comment: '完成状态1:未完成doing 2:已完成done'
    add_column :task_volunteers, :source, :string, comment: '获得来源'
  end
end
