class AddProjectSeasonApplyBookshelfToDonateRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :donate_records, :project_season_apply_bookshelf_id, :integer, comment: '书架id'
  end
end
