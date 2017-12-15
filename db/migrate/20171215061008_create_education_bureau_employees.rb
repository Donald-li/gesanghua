class CreateEducationBureauEmployees < ActiveRecord::Migration[5.1]
  def change
    create_table :education_bureau_employees, comment: '教育局工作人员表' do |t|
      t.string :name, comment: '姓名'
      t.string :phone, comment: '联系方式'
      t.string :nickname, comment: '昵称'
      t.integer :kind, comment: '类型，1：局长 2：员工', default: 1
      t.integer :education_bureau_id, comment: '教育局id'

      t.timestamps
    end
  end
end
