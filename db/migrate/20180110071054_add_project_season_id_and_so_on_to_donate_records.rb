class AddProjectSeasonIdAndSoOnToDonateRecords < ActiveRecord::Migration[5.1]
  def change
    remove_column :donate_records, :project_apply_id, :integer
    add_column :donate_records, :project_season_id, :integer, comment: '年度ID'
    add_column :donate_records, :project_season_apply_id, :integer, comment: '年度项目ID'
    add_column :donate_records, :project_season_apply_child_id, :integer, comment: '年度孩子申请ID'
    add_column :donate_records, :donate_no, :string, comment: '捐赠编号'
  end
end
