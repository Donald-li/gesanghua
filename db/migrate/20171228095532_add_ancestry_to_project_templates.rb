class AddAncestryToProjectTemplates < ActiveRecord::Migration[5.1]
  def change
    add_column :project_templates, :ancestry, :string
    add_index :project_templates, :ancestry
  end
end
