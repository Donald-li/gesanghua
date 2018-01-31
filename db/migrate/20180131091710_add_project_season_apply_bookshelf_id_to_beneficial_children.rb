class AddProjectSeasonApplyBookshelfIdToBeneficialChildren < ActiveRecord::Migration[5.1]
  def change
    drop_table :gsh_bookshelves
    remove_column :beneficial_children, :gsh_bookshelf_id, :integer
    remove_column :project_season_apply_bookshelves, :gsh_bookshelf_id, :integer

    add_column :beneficial_children, :project_season_apply_bookshelf_id, :integer, comment: '书架id'
  end
end
