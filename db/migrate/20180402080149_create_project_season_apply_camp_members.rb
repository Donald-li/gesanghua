class CreateProjectSeasonApplyCampMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :project_season_apply_camp_members do |t|
      t.string :name, comment: '姓名'
      t.string :id_card, comment: '身份证号'
      t.integer :nation, comment: '民族'
      t.integer :gender, comment: '性别'
      t.integer :school_id, comment: '学校id'
      t.integer :project_season_apply_camp_id, comment: '探索营配额id'
      t.integer :camp_id, comment: '探索营id'
      t.integer :project_season_apply_id, comment: '营立项id'
      t.integer :grade, comment: '年级'
      t.integer :level, comment: '初高中'
      t.string :teacher_name, comment: '老师姓名'
      t.string :teacher_phone, comment: '老师联系方式'
      t.string :guardian_name, comment: '监护人姓名'
      t.string :guardian_phone, comment: '监护人联系方式'
      t.text :description, comment: '自我介绍'
      t.string :reason, comment: '推荐理由'
      t.integer :state, comment: '状态'
      t.integer :age, comment: '年龄'
      t.integer :kind, comment: '类型 1学生 2老师'
      t.timestamps
    end
  end
end
