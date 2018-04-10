class AddColumnProjectIdsToTableUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :project_ids, :jsonb, default: [], comment: '可管理项目（项目管理员）'
  end
end
