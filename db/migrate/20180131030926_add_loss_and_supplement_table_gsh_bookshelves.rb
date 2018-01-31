class AddLossAndSupplementTableGshBookshelves < ActiveRecord::Migration[5.1]
  def change
    add_column :gsh_bookshelves, :loss, :integer, comment: '书籍损耗'
    add_column :gsh_bookshelves, :supplement, :integer, comment: '书籍补充'
  end
end
