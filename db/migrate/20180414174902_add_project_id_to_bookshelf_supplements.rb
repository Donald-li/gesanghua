class AddProjectIdToBookshelfSupplements < ActiveRecord::Migration[5.1]
  def change
    add_column :bookshelf_supplements, :project_id, :integer, comment: '项目id'
  end
end
