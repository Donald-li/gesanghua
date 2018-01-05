class CreatePeriodChildShips < ActiveRecord::Migration[5.1]
  def change
    create_table :period_child_ships, comment: '年度孩子和申请学期中间表' do |t|
      t.integer :project_season_apply_period_id, comment: '申请学期ID'
      t.integer :project_season_apply_child_id, comment: '年度孩子ID'

      t.timestamps
    end
  end
end
