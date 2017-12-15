class CreateChildGrants < ActiveRecord::Migration[5.1]
  def change
    create_table :child_grants, comment: '孩子发放记录表' do |t|
      t.integer :child_id, comment: '孩子ID'
      t.integer :project_apply_id, comment: '项目申请ID'
      t.integer :state, comment: '状态'

      t.timestamps
    end
  end
end
