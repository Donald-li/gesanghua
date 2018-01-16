class AddProjectIdAndSoOnToTableReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :project_id, :integer, comment: '项目ID'
    add_column :reports, :published_at, :datetime, comment: '发布时间'
    add_column :reports, :position, :integer, comment: '位置'
    add_column :reports, :user_id, :integer, comment: '发布人'
  end
end
