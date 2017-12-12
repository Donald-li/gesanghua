class CreateAdverts < ActiveRecord::Migration[5.1]
  def change
    create_table :adverts, comment: '广告表' do |t|
      t.integer :kind, comment: '分类'
      t.string :title, comment: '标题'
      t.string :description, comment: '描述'
      t.string :url, comment: '链接'
      t.integer :views_count, comment: '展示次数'
      t.integer :kind_position, comment: '分类排序'
      t.integer :state, comment: '状态'
      t.integer :user_id, comment: '用户id'

      t.timestamps
    end
  end
end
