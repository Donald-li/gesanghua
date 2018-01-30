class AddStudentNumberToTableGshBookshelves < ActiveRecord::Migration[5.1]
  def change
    add_column :gsh_bookshelves, :student_number, :integer, comment: '班级人数'
  end
end
