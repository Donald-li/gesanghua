class AddTwoColumnToProjectSeasonApply < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_applies, :target_amount, :decimal, precision: 14, scale: 2, default: "0", comment: '目标金额'
    add_column :project_season_applies, :present_amount, :decimal, precision: 14, scale: 2, default: "0", comment: '目前已筹金额'
    add_column :project_season_applies, :execute_state, :integer, default: 0, comment: '执行状态：0:准备中 1:筹款中 2:待执行 3:待收货 4:待反馈 5:已完成'
    add_column :project_season_applies, :project_type, :integer, default: 1, comment: '项目类型:1:申请 2:筹款项目'
  end
end
