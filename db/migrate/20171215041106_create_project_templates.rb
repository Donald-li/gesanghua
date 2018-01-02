class CreateProjectTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :project_templates, comment: '项目模板表' do |t|
      t.string :name, comment: '项目模板名称'
      t.integer :kind, comment: '模板类型'
      t.integer :fund_id, comment: '基金ID'
      t.string :protocol_name, comment: '协议名称'
      t.text :protocol_content, comment: '协议内容'
      t.integer :contribute_kind, comment: '捐款类型：1:整捐 2:零捐', default: 1

      t.timestamps
    end
  end
end
