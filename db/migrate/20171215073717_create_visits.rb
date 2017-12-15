class CreateVisits < ActiveRecord::Migration[5.1]
  def change
    create_table :visits, comment: '家访记录表' do |t|
      t.integer :owner_id
      t.string :owner_type
      t.text :content, comment: '内容'

      t.timestamps
    end
  end
end
