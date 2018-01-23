class CreateProjectReports < ActiveRecord::Migration[5.1]
  def change
    create_table :project_reports, comment: '项目报告表' do |t|
      t.string :title, comment: '标题'
      t.text :content, comment: '内容'
      t.integer :state, comment: '状态：1显示 2隐藏'
      t.integer :project_id, comment: '项目id'
      t.datetime :published_at, comment: '发布时间'
      t.integer :kind, comment: '类型: 1项目报告 2回访报告'
      t.integer :position, comment: '位置'
      t.integer :user_id, comment: '发布人'

      t.timestamps
    end
  end
end
