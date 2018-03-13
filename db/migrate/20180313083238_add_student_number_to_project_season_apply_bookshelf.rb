class AddStudentNumberToProjectSeasonApplyBookshelf < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_bookshelves, :student_number, :integer, default: 0, comment: '班级学生人数'
  end
end
