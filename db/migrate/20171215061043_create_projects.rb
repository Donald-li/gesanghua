class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects, comment: '项目表' do |t|
      t.string :name, comment: '项目名称'
      t.string :type, comment: '项目类型：1:结对 2:物资 3:悦读 4:营 5:观影'
      t.text :content, comment: '项目内容'
      t.integer :state, comment: '项目状态：1:启用 2:禁用', default: 1
      t.integer :finance_category_id, comment: '财务分类ID'
      t.integer :contribute_kind, comment: '捐款类型：1:整捐 2:零捐', default: 1
      t.string :category_type, comment: '具体项目分类'
      t.integer :category_id, comment: '分类ID'
      t.integer :project_template_id, comment: '项目模板ID'

      t.timestamps
    end
  end
end
