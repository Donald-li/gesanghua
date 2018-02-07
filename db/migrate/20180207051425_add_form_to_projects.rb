class AddFormToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :form, :jsonb, comment: '自定义表单{key, label, type, options, required}'
    add_column :project_season_applies, :form, :jsonb, comment: '自定义表单{key, value}'
  end
end
