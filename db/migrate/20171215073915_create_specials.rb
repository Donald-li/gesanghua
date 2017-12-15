class CreateSpecials < ActiveRecord::Migration[5.1]
  def change
    create_table :specials do |t|
      t.string :name, comment: '位置'
      t.integer :template, comment: '位置'
      t.integer :describe, comment: '位置'
      t.integer :article_name, comment: '位置'

      t.timestamps
    end
  end
end
