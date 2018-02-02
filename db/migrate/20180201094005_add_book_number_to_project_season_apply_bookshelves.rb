class AddBookNumberToProjectSeasonApplyBookshelves < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_bookshelves, :book_number, :integer, comment: '书籍数量'
  end
end
