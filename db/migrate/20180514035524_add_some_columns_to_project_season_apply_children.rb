class AddSomeColumnsToProjectSeasonApplyChildren < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_apply_children, :expenditure_information, :text, comment: '支出详情'
    add_column :project_season_apply_children, :debt_information, :text, comment: '负债情况'
    add_column :project_season_apply_children, :parent_information, :string, comment: '父母情况'
  end
end
