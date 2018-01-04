class CreateProjectSeasonApplyChildren < ActiveRecord::Migration[5.1]
  def change
    create_table :project_season_apply_children, comment: '项目执行年度申请的孩子表' do |t|
      t.integer :project_id, comment: '关联项目id'
      t.integer :project_season_id, comment: '关联项目执行年度id'
      t.integer :project_season_apply_id, comment: '关联项目执行年度申请id'
      t.integer :gsh_child_id, comment: '关联格桑花孩子表id'
      t.string :name, comment: '孩子姓名'
      t.string :province, comment: '省'
      t.string :city, comment: '市'
      t.string :district, comment: '区/县'

      t.timestamps
    end
  end
end
