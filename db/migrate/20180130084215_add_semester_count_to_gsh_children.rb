class AddSemesterCountToGshChildren < ActiveRecord::Migration[5.1]
  def change
    add_column :gsh_children, :semester_count, :integer, default: 0, comment: '孩子申请学期总数'
    add_column :gsh_children, :done_semester_count, :integer, default: 0, comment: '孩子募款成功学期总数'
  end
end
