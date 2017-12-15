class CreateEducationBureauEmployees < ActiveRecord::Migration[5.1]
  def change
    create_table :education_bureau_employees, comment: '教育局工作人员表' do |t|
      t.string :name, comment: '姓名'
      t.string :phone, comment: '联系方式'
      t.string :nickname, comment: '昵称'
      t.integer :kind, comment: '类型，1：员工 2：局长', default: 1

      t.timestamps
    end
  end
end
