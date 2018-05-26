class AddArchiveDataToTables < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :archive_data, :jsonb, comment: '归档旧数据'
    add_column :schools, :archive_data, :jsonb, comment: '归档旧数据'
    add_column :teachers, :archive_data, :jsonb, comment: '归档旧数据'
    add_column :volunteers, :archive_data, :jsonb, comment: '归档旧数据'
    add_column :project_season_apply_children, :archive_data, :jsonb, comment: '归档旧数据'
    add_column :income_records, :archive_data, :jsonb, comment: '归档旧数据'
    add_column :donate_records, :archive_data, :jsonb, comment: '归档旧数据'
  end
end
