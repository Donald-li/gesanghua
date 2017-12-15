class CreateEducationBureaus < ActiveRecord::Migration[5.1]
  def change
    create_table :education_bureaus, comment: '教育局表' do |t|
      t.string :name, comment: '名称'
      t.string :address, comment: '详细地址'
      t.string :province, comment: '省'
      t.string :city, comment: '市'
      t.string :district, comment: '区/县'

      t.timestamps
    end
  end
end
