class ChangeUpplyToTableBookshelfSupplements < ActiveRecord::Migration[5.1]
  def change
    remove_column :bookshelf_supplements, :upply
    add_column :bookshelf_supplements, :supply, :integer, comment: '补充数量'
  end
end
