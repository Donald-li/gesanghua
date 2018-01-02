class AddSomeColumnsToTableProjectApply < ActiveRecord::Migration[5.1]
  def change
    add_column :project_applies, :number, :integer, comment: '学生数量'
    add_column :project_applies, :name, :string, comment: '申请名称'
  end
end
