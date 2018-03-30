class CreateProjectSeasonApplyCampTeachers < ActiveRecord::Migration[5.1]
  def change
    create_table :project_season_apply_camp_teachers, comment: '探索营老师名单' do |t|
      t.string :name, comment: '姓名'
      t.string :id_card, comment: '身份证号'
      t.integer :nation, comment: '民族'
      t.integer :gender, comment: '性别'
      t.string :phone, comment: '联系方式'
      t.integer :state, comment: '状态'
      t.integer :school_id, comment: '学校id'
      t.integer :project_season_apply_camp_id, comment: '探索营配额id'
      t.integer :camp_id, comment: '探索营id'
      t.integer :project_season_apply_id, comment: '营立项id'

      t.timestamps
    end
  end
end
