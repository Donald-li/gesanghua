class CreateRemarks < ActiveRecord::Migration[5.1]
  def change
    create_table :remarks, comment: '备注信息' do |t|
      t.text :content, comment: '内容'
      t.string :owner_type, comment: ''
      t.integer :owner_id, comment: ''
      t.integer :operator_type, comment: '操作类型'
      t.integer :operator_id, comment: ''
      
      t.timestamps
    end
  end
end