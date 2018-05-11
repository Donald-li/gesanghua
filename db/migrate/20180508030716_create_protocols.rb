class CreateProtocols < ActiveRecord::Migration[5.1]
  def change
    create_table :protocols, comment: '协议' do |t|
      t.integer :kind, comment: '类型'
      t.string :title, comment: '标题'
      t.text :content, comment: '内容'
      t.string :version, comment: '版本'
      t.integer :project_id, comment: '关联项目id'
      t.integer :state, comment: '状态'
      t.timestamps
    end
  end
end
