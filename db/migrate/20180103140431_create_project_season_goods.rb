class CreateProjectSeasonGoods < ActiveRecord::Migration[5.1]
  def change
    create_table :project_season_goods, comment: '物资类项目，执行年度的物品表' do |t|
      t.integer :project_id, comment: '关联项目id'
      t.integer :project_season_id, comment: '关联执行年度id'
      t.string :name, comment: '物品名称'

      t.timestamps
    end
  end
end
