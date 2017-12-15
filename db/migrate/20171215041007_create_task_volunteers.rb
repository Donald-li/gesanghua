class CreateTaskVolunteers < ActiveRecord::Migration[5.1]
  def change
    create_table :task_volunteers, comment: '任务的志愿者表' do |t|
      t.integer :task_id, comment: '任务id'
      t.integer :volunteer_id, comment: '志愿者id'
      t.string :comment, comment: '管理员评论'
      t.text :achievement_comment, comment: '成果描述'
      t.integer :duration, comment: '时长'
      t.integer :approve_state, comment: '审核状态'

      t.timestamps
    end
  end
end
