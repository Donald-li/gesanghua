class CreateProjectSeasons < ActiveRecord::Migration[5.1]
  def change
    create_table :project_seasons, comment: '项目执行年度表' do |t|
      t.integer :project_id, comment: '关联项目表id'
      t.string :name, comment: '执行年度名称'
      t.integer :state, comment: '状态 1:未执行 2:执行中'

      t.timestamps
    end
  end
end
