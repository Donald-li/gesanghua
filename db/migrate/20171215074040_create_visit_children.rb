class CreateVisitChildren < ActiveRecord::Migration[5.1]
  def change
    create_table :visit_children, comment: '家访记录学生表' do |t|
      t.integer :visit_id, comment: '家访ID'
      t.integer :child_id, comment: '孩子ID'

      t.timestamps
    end
  end
end
