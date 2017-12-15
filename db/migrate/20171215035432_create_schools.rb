class CreateSchools < ActiveRecord::Migration[5.1]
  def change
    create_table :schools, comment: '学校表' do |t|
      t.string :name, comment: '学校名称'
      t.string :address, comment: '地址'
      t.integer :approve_state, comment: '审核状态：1:待审核 2:通过 3:不通过', default: 1
      t.string :approve_remark, comment: '审核备注'
      t.string :province, comment: '省'
      t.string :city, comment: '市'
      t.string :district, comment: '区/县'
      t.integer :number, comment: '学校人数'
      t.string :describe, comment: '学校简介'
      t.integer :state, comment: '学校状态：1:启用 2:禁用', default: 1

      t.timestamps
    end
  end
end
