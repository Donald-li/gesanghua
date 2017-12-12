class CreatePages < ActiveRecord::Migration[5.1]
  def change
    create_table :pages, comment: '单页面' do |t|
      t.string :title, comment: '标题'
      t.string :alias, comment: '别名'
      t.text :content, comment: '内容'
      t.integer :position, comment: '排序'
      t.integer :state, comment: '状态'

      t.timestamps
    end
  end
end
