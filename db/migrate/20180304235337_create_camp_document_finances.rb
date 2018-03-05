class CreateCampDocumentFinances < ActiveRecord::Migration[5.1]
  def change
    create_table :camp_document_finances, comment: '拓展营预决算表' do |t|
      t.integer :project_id, comment: '项目'
      t.integer :user_id, comment: '用户'
      t.string :item, comment: '项'
      t.decimal :budge, precision: 14, scale: 2, default:  0.0, comment: '预算'
      t.decimal :amount, precision: 14, scale: 2, default:  0.0, comment: '决算'
      t.string :remark, comment: '备注'

      t.timestamps
    end
  end
end
