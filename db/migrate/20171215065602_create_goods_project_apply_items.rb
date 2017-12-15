class CreateGoodsProjectApplyItems < ActiveRecord::Migration[5.1]
  def change
    create_table :goods_project_apply_items, comment: '物资类项目申请条目表' do |t|
      t.string :name, comment: '物品名称'
      t.integer :number, comment: '物品数量'

      t.timestamps
    end
  end
end
