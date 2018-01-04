class AddColumnsToTableTaskVolunteer < ActiveRecord::Migration[5.1]
  def change
    add_column :task_volunteers, :finish_time, :datetime, comment: '任务完成时间'
    add_column :task_volunteers, :approve_time, :datetime, comment: '审核时间'
  end
end
