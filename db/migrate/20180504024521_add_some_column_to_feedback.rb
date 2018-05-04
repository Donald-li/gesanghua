class AddSomeColumnToFeedback < ActiveRecord::Migration[5.1]
  def change
    add_column :feedbacks, :arise_at, :datetime, comment: '开展时间'
    add_column :feedbacks, :arise_class, :string, comment: '开展班级'
    add_column :feedbacks, :number, :integer, comment: '参与人数'
    add_column :projects, :feedback_format, :integer, comment: '反馈形式'
  end
end
