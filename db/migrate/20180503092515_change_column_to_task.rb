class ChangeColumnToTask < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :principal, :string, comment: '任务负责人'
    Task.all.each { |t| t.update(principal: t.principal.try(:name))}
    remove_column :tasks, :principal_id, :integer
  end
end
