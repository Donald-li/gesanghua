class CreateProjectSeasonCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :project_season_courses, comment: '项目执行年度的课程表(例：护花)' do |t|
      t.integer :project_id, comment: '关联项目id'
      t.integer :project_season_id, comment: '关联项目执行年度id'
      t.string :name, comment: '课程名称'

      t.timestamps
    end
  end
end
