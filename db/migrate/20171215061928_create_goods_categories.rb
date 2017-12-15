class CreateGoodsCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :goods_categories, comment: '物资分类' do |t|
      t.string :name, comment: '名称'

      t.timestamps
    end
  end
end
