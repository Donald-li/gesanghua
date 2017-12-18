class CreateSupportCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :support_categories, comment: '帮助主题分类' do |t|
      t.string :name, comment: '名称'
      t.string :describe, comment: '描述'
      t.integer :position, comment: '排序'
      t.integer :state, comment: '状态 1:显示 2:隐藏'

      t.timestamps
    end
  end
end
