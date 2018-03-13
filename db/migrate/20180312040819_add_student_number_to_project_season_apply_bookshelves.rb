class AddStudentNumberToProjectSeasonApplyBookshelves < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_bookshelves, :student_number, :integer, comment: '班级人数'
    add_column :project_season_apply_bookshelves, :contact_name, :string, comment: '联系人'
    add_column :project_season_apply_bookshelves, :contact_phone, :string, comment: '联系电话'
    add_column :project_season_apply_bookshelves, :address, :string, comment: '详细地址'
  end
end
