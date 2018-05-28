class AddAuthorAndArticleIdToSpecials < ActiveRecord::Migration[5.1]
  def change
    add_column :specials, :author, :string, comment: '编辑人'
    add_column :specials, :article_id, :integer, comment: '资讯id'
  end
end
