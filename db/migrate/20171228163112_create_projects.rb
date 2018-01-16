class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :type, comment: '单表继承字段'
      t.integer :kind, comment: '项目类型 1:固定项目 2:物资类项目'
      t.string :name, comment: '项目名称'
      t.text :describe, comment: '简介'
      t.text :protocol, comment: '用户协议'
      t.integer :fund_id, comment: '关联财务分类id'

      t.timestamps
    end
  end
end
