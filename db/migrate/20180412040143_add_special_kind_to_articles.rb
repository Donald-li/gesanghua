class AddSpecialKindToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :special_kind, :integer, comment: '专题类型： 1:文字新闻 2:图片新闻'
  end
end
