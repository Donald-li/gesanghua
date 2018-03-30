class CreateProjectSeasonApplyCamps < ActiveRecord::Migration[5.1]
  def change
    create_table :project_season_apply_camps, comment: '探索营配额' do |t|
      t.integer :project_season_apply_id, comment: '营立项id'
      t.integer :camp_id, comment: '探索营id'
      t.integer :school_id, comment: '学校id'
      t.text :describe, comment: '申请要求'
      t.integer :student_number, comment: '学生数量'
      t.integer :teacher_number, comment: '陪同老师数量'
      t.datetime :end_time, comment: '申请截止时间'
      t.integer :time_limit, comment: '是否设置截止时间'
      t.integer :message_type, comment: '通知方式'
      t.integer :state, comment: '状态'

      t.timestamps
    end
  end
end
