class CreateTeacherProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :teacher_projects, comment: '老师项目表' do |t|
      t.integer :teacher_id, comment: '老师id'
      t.integer :project_id, comment: '项目id'

      t.timestamps
    end
  end
end
