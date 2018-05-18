class CreateExceptionRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :exception_records do |t|
      t.string :title, comment: '标题'
      t.string :content, comment: '内容'
      t.string :schedule, comment: '进度更新'
      t.string :owner_type, comment: ''
      t.integer :owner_id, comment: ''
      t.integer :user_id, comment: '提交人id'

      t.timestamps
    end
  end
end
