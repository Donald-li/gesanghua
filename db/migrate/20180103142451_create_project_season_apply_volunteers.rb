class CreateProjectSeasonApplyVolunteers < ActiveRecord::Migration[5.1]
  def change
    create_table :project_season_apply_volunteers, comment: '项目执行年度申请和志愿者关联表' do |t|
      t.integer :project_id, comment: '关联项目id'
      t.integer :project_season_id, comment: '关联项目执行年度id'
      t.integer :project_season_apply_id, comment: '关联项目执行年度的申请id'
      t.integer :volunteer_id, comment: '关联志愿者id'

      t.timestamps
    end
  end
end
