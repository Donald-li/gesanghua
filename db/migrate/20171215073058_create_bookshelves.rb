class CreateBookshelves < ActiveRecord::Migration[5.1]
  def change
    create_table :bookshelves, comment: '书架表' do |t|
      t.string :title, comment: '名称'
      t.integer :school_id, comment: '学校id'
      t.string :class_name, comment: '班级名'
      t.integer :state, comment: '状态'
      t.decimal :balance, precision: 14, scale: 2, default: "0.0", comment: '剩余金额'
      t.integer :project_apply_id, comment: '项目申请id'

      t.timestamps
    end
  end
end
