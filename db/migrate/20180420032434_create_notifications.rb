class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.integer :push_type, comment: 'bit_enum，邮件、短信、微信'
      t.string :kind, comment: '类型，通知类型'
      t.integer :from_user_id, comment: '发起用户'
      t.integer :user_id, comment: '通知用户'
      t.integer :project_id, comment: '项目'
      t.integer :project_season_id, comment: '批次'
      t.integer :project_season_apply_id, comment: '申请'
      t.string :owner_type
      t.integer :owner_id
      t.text :content, comment: '内容'
      t.boolean :read, comment: '是否已读'

      t.timestamps
    end
  end
end
