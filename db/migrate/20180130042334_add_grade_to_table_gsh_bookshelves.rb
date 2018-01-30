class AddGradeToTableGshBookshelves < ActiveRecord::Migration[5.1]
  def change
    add_column :gsh_bookshelves, :grade, :integer, comment: '所属年级'
  end
end
