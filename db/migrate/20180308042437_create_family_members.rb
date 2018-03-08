class CreateFamilyMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :family_members, comment: '家庭成员表' do |t|
      t.integer :visit_id, comment: '家访表ID'
      t.string :name, comment: '成员姓名'
      t.integer :age, comment: '年龄'
      t.string :relationship, comment: '关系'
      t.string :profession, comment: '职业'
      t.text :health_condition, comment: '健康状况'
      t.text :job_condition, comment: '工作情况'

      t.timestamps
    end
  end
end
