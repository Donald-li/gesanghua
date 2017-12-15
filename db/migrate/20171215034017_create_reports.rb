class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports, comment: '报告表' do |t|
      t.string :title, comment: '标题'
      t.text :content, comment: '内容'
      t.string :owner_type, comment: ''
      t.integer :owner_id, comment: ''
      t.integer :type, comment: '单表：audit_report、financial_report、project_report'
      t.integer :state, comment: '状态'

      t.timestamps
    end
  end
end
