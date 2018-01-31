class AddTwoColumnsToProjectSeasonApply < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_applies, :class_number, :integer, comment: '申请班级数'
    add_column :project_season_applies, :student_number, :integer, comment: '受益学生数'
  end
end
