class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles, comment: '资讯表' do |t|
      t.string :title, comment: '标题'
      t.text :content, comment: '内容'
      t.integer :state, default: 1, comment: '状态, 1:展示 2:隐藏'
      t.integer :recommend, default: 0, comment: '推荐 0:正常 1:推荐'
      t.integer :article_category_id, comment: '资讯分类id'
      t.datetime :published_at, comment: '发布时间'
      t.string :author, comment: '作者'
      t.string :source, comment: '来源'
      t.text :describe, comment: '摘要'

      t.timestamps
    end
  end
end
