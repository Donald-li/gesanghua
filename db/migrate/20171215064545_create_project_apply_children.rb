class CreateProjectApplyChildren < ActiveRecord::Migration[5.1]
  def change
    create_table :project_apply_children, comment: '一对一孩子申请表' do |t|
      t.integer :project_apply_id, comment: '项目申请ID'
      t.integer :child_id, comment: '格桑花孩子ID'
      t.integer :approve_state, comment: '审核状态：1:审核中 2:申请通过 3:申请不通过'
      t.string :province, comment: '省'
      t.string :city, comment: '市'
      t.string :district, comment: '区/县'

      t.timestamps
    end
  end
end
