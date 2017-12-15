class CreateSpecialArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :special_articles do |t|

      t.timestamps
    end
  end
end
