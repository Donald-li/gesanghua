class CreateSpecialArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :special_articles, comment: '专题资讯表' do |t|
      t.integer :special_id, comment: '专题id'
      t.integer :article_id, comment: '资讯id'
      t.integer :position, comment: '排序'

      t.timestamps
    end
  end
end
