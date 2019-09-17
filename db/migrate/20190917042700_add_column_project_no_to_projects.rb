class AddColumnProjectNoToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :project_no, :string, comment: '项目编号'
  end
end
