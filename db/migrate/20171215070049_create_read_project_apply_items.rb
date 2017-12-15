class CreateReadProjectApplyItems < ActiveRecord::Migration[5.1]
  def change
    create_table :read_project_apply_items, comment: '悦读类项目申请条目表' do |t|
      t.string :name, comment: '名称'
      t.integer :number, comment: '数量'
      t.decimal :balance, precision: 14, scale: 2, default: "0.0", comment: '余额'
      t.string :title, comment: '冠名'

      t.timestamps
    end
  end
end
