class CreateProjectSeasonApplyGooods < ActiveRecord::Migration[5.1]
  def change
    create_table :project_season_apply_gooods, comment: '项目执行年度申请的物品表' do |t|
      t.integer :project_id, comment: '关联项目id'
      t.integer :project_season_id, comment: '关联项目执行年度id'
      t.integer :project_season_apply_id, comment: '关联项目执行年度申请id'
      t.integer :project_season_goods_id, comment: '关联项目执行年度物品id'
      t.integer :num, comment: '物品申请数量'

      t.timestamps
    end
  end
end
