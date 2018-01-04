class AddKindToArticle < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :kind, :integer, comment: '类型'
    add_column :special_adverts, :kind, :integer, comment: '类型'
  end
end
