class AddColumnTaskNoToTask < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :task_no, :string, comment: '任务编号'
  end
end
