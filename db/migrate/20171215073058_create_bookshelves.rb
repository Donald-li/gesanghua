class CreateBookshelves < ActiveRecord::Migration[5.1]
  def change
    create_table :bookshelves, comment: '书架表' do |t|
      t.string :title, comment: '名称'
      t.integer :school_id, comment: '学校id'
      t.string :class_name, comment: '班级名'

      t.timestamps
    end
  end
end
