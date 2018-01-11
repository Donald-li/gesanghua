class AddColunmKindToTask < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :kind, :integer, commnet: '类型 1：普通任务 2：指派任务'
  end
end
