class AddClassNameToFeedbacks < ActiveRecord::Migration[5.1]
  def change
    add_column :feedbacks, :class_name, :string, comment: '反馈班级'
  end
end
