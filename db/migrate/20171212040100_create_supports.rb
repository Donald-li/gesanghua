class CreateSupports < ActiveRecord::Migration[5.1]
  def change
    create_table :supports, comment: '帮助中心主题' do |t|
      t.string :title, comment: '标题'
      t.string :alias, comment: '别名'
      t.text :content, comment: '内容'
      t.integer :position, comment: '排序'
      t.integer :state, comment: '状态'
      t.integer :support_category_id, comment: '帮助中心分类id'

      t.timestamps
    end
  end
end
