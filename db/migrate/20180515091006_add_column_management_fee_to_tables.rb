class AddColumnManagementFeeToTables < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_applies, :management_fee_state, :integer, comment: '计提管理费状态'
    add_column :project_season_apply_children, :management_fee_state, :integer, comment: '计提管理费状态'
    add_column :project_season_apply_bookshelves, :management_fee_state, :integer, comment: '计提管理费状态'
    add_column :bookshelf_supplements, :management_fee_state, :integer, comment: '计提管理费状态'

    ProjectSeasonApply.update_all(management_fee_state: 0)
    ProjectSeasonApplyChild.update_all(management_fee_state: 0)
    ProjectSeasonApplyBookshelf.update_all(management_fee_state: 0)
    BookshelfSupplement.update_all(management_fee_state: 0)
  end
end
