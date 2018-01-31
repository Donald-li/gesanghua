class AddProjectIdToFeedbacks < ActiveRecord::Migration[5.1]
  def change
    add_column :feedbacks, :project_id, :integer, comment: '项目id'
    add_column :feedbacks, :project_season_id, :integer, comment: '批次id'
    add_column :feedbacks, :project_season_apply_id, :integer, comment: '申请id'
    add_column :feedbacks, :project_season_apply_child_id, :integer, comment: '孩子id'
    add_column :feedbacks, :project_season_apply_bookshelf_id, :integer, comment: '书架id'
  end
end
