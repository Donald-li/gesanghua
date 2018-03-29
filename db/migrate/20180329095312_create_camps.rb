class CreateCamps < ActiveRecord::Migration[5.1]
  def change
    create_table :camps, comment: '探索营' do |t|
      t.string :name, comment: '名称'
      t.string :province, comment: '省'
      t.string :city, comment: '市'
      t.string :district, comment: '区、县'
      t.integer :fund_id, comment: '资金id'
      t.integer :manager_id, comment: '负责人id'
      t.integer :state, comment: '状态：1:启用 2:禁用）'

      t.timestamps
    end
  end
end
