class CreateWorkplaces < ActiveRecord::Migration[5.1]
  def change
    create_table :workplaces, comment: '任务地点' do |t|
      t.string :title, comment: '名称'
      t.string :province, comment: '省'
      t.string :city, comment: '市'
      t.string :district, comment: '区县'
      t.string :address, comment: '详细地址'
      t.text :describe, comment: '描述'
      t.integer :state, default: 1, comment: '显示状态：1:显示 2:隐藏'

      t.timestamps
    end
  end
end
