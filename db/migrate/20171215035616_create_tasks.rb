class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks, comment: '任务表' do |t|
      t.string :name, comment: '任务名'      
      t.integer :duration, comment: '时长'      
      t.integer :content, comment: '内容'      
      t.integer :num, comment: '人数'      
      t.integer :state, comment: '状态'      
      t.integer :major_id, comment: '等级'      
      t.integer :province, comment: '省'      
      t.integer :city, comment: '市'      
      t.integer :district, comment: '区'      
      
      t.timestamps
    end
  end
end


 