class AddColumnCommentToProjectReport < ActiveRecord::Migration[5.1]
  def change
    add_column :project_reports, :comment, :text
  end
end
