class CreateArticleCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :article_categories, comment: '文章类别表' do |t|
      t.string :name, comment: '名称'
      t.integer :position, comment: '位置'
      t.integer :state, comment: '状态'
      t.string :describe, comment: '描述'

      t.timestamps
    end
  end
end
