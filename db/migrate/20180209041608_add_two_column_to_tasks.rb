class AddTwoColumnToTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :task_category_id, :integer, comment: '任务分类ID'
    add_column :tasks, :workplace_id, :integer, comment: '工作地点ID'
    add_column :tasks, :types_mask, :integer, comment: '任务类型'
    add_column :tasks, :apply_end_at, :datetime, comment: '申请结束时间'
    add_column :tasks, :principal_id, :integer, comment: '任务负责人'
  end
end
