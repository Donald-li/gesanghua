class AddAliasToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :alias, :string, comment: '项目别名，使用英文'
  end
end
