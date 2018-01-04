class CreateGshBookshelves < ActiveRecord::Migration[5.1]
  def change
    create_table :gsh_bookshelves do |t|
      t.integer :school_id, comment: '关联学校id'
      t.string :classname, comment: '班级名'
      t.string :title, comment: '冠名'
      t.string :province, comment: '省'
      t.string :city, comment: '市'
      t.string :district, comment: '区/县'

      t.timestamps
    end
  end
end
