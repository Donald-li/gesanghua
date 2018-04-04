class CreateProjectSeasonApplyInventories < ActiveRecord::Migration[5.1]
  def change
    create_table :project_season_apply_inventories, comment: '筹款项目物资清单' do |t|
      t.integer :project_season_apply_id, comment: '项目id'
      t.string :name, comment: '名称'
      t.decimal :unit, precision: 14, scale: 2, default: "0.0", comment: '单价（元）'
      t.integer :number, comment: '数量'
      t.integer :state, comment: '状态'

      t.timestamps
    end
  end
end
