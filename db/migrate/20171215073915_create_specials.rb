class CreateSpecials < ActiveRecord::Migration[5.1]
  def change
    create_table :specials, comment: '专题表' do |t|
      t.string :name, comment: '专题名'
      t.integer :template, comment: '模板'
      t.string :describe, comment: '简介'
      t.string :article_name, comment: '资讯名称'

      t.timestamps
    end
  end
end
