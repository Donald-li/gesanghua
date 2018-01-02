class CreateCountyUsers < ActiveRecord::Migration[5.1]
  def change
    drop_table :education_bureau_employees
    drop_table :education_bureaus

    create_table :county_users do |t|
      t.string :name, comment: '姓名'
      t.string :phone, comment: '联系方式'
      t.string :unit_name, comment: '单位名称'
      t.string :unit_describe, comment: '单位简介'
      t.integer :user_id, comment: '用户id'
      t.string :address, comment: '详细地址'
      t.string :province, comment: '省'
      t.string :city, comment: '市'
      t.string :district, comment: '区/县'

      t.timestamps
    end
  end
end
