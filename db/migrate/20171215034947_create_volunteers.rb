class CreateVolunteers < ActiveRecord::Migration[5.1]
  def change
    create_table :volunteers, comment: '志愿者表' do |t|
      t.integer :level, comment: '等级'
      t.integer :major_id, comment: '专业id'
      t.integer :duration, comment: '服务时长'
      t.integer :user_id, comment: '用户'
      t.integer :job_state, comment: '任务状态'
      t.integer :state, comment: '状态'

      t.timestamps
    end
  end
end