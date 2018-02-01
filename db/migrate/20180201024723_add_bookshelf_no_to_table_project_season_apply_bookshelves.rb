class AddBookshelfNoToTableProjectSeasonApplyBookshelves < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_bookshelves, :bookshelf_no, :string, comment: '图书角编号'
    add_column :project_season_applies, :project_describe, :text, comment: '项目介绍'
  end
end
