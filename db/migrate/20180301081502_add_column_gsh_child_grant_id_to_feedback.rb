class AddColumnGshChildGrantIdToFeedback < ActiveRecord::Migration[5.1]
  def change
    add_column :feedbacks, :gsh_child_grant_id, :integer, comment: '学生某学期的持续反馈（感谢信）'
  end
end
