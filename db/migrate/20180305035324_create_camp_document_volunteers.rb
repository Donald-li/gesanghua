class CreateCampDocumentVolunteers < ActiveRecord::Migration[5.1]
  def change
    create_table :camp_document_volunteers, comment: '拓展营志愿者表' do |t|
      t.integer :project_id, comment: '项目'
      t.integer :user_id, comment: '用户'
      t.integer :volunteer_id, comment: '志愿者'
      t.string :remark, comment: '营备注'

      t.timestamps
    end
  end
end
