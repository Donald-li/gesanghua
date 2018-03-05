class CreateCampDocumentResources < ActiveRecord::Migration[5.1]
  def change
    create_table :camp_document_resources, comment: '拓展营资源表' do |t|
      t.integer :project_id, comment: '项目'
      t.integer :user_id, comment: '用户'
      t.string :company, comment: '单位名称'
      t.string :resource, comment: '资源名称'
      t.string :contact_name, comment: '联系人'
      t.string :contact_phone, comment: '联系人电话'
      t.string :gsh_contact_name, comment: '格桑花联系人'
      t.string :gsh_contact_phone, comment: '格桑花联系人电话'
      t.string :remark, comment: '资源说明'

      t.timestamps
    end
  end
end
