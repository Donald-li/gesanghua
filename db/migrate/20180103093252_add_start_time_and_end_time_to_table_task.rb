class AddStartTimeAndEndTimeToTableTask < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :start_time, :datetime, comment: '任务开始时间'
    add_column :tasks, :end_time, :datetime, comment: '任务结束时间'
  end
end
