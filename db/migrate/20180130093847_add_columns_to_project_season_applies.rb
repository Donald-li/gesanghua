class AddColumnsToProjectSeasonApplies < ActiveRecord::Migration[5.1]
  def change
    add_column :project_season_applies, :fundraising_target, :decimal, precision: 14, scale: 2, default: "0", comment: '筹款目标金额'
    add_column :project_season_applies, :raised_amount, :decimal, precision: 14, scale: 2, default: "0", comment: '已筹金额'
    add_column :project_season_applies, :execute_state, :integer, comment: '执行状态 1:筹款中 2:待执行 3:待收货 4:待反馈 5:已完成'
    add_column :project_season_applies, :fundraising_state, :integer, comment: '对外筹款状态 1:对外筹款 2:不对外筹款'
  end
end
