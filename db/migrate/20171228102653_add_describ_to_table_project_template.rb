class AddDescribToTableProjectTemplate < ActiveRecord::Migration[5.1]
  def change
    add_column :project_templates, :describe, :text, comment: '描述'
  end
end
