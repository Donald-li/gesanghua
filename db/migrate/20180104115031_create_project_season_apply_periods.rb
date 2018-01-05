class CreateProjectSeasonApplyPeriods < ActiveRecord::Migration[5.1]
  def change
    create_table :project_season_apply_periods, comment: '项目申请时长' do |t|
      t.string :name, comment: '名称'
      t.integer :kind, comment: '类型'
      t.integer :state, comment: '状态'
      t.string :desciption, comment: '描述'
      t.datetime :start_at, comment: '开始时间'
      t.datetime :end_at, comment: '结束时间'

      t.timestamps
    end
  end
end
