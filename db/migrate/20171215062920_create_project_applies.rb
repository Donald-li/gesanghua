class CreateProjectApplies < ActiveRecord::Migration[5.1]
  def change
    create_table :project_applies, comment: '项目申请表' do |t|
      t.integer :user_id, comment: '用户ID'
      t.integer :project_id, comment: '项目ID'
      t.integer :state, comment: '状态：1:展示 2:隐藏', default: 1
      t.integer :approve_state, comment: '申请状态：1:待审核 2:审核通过 3:审核不通过', default: 1
      t.integer :school_id, comment: '学校ID'
      t.string :province, comment: '省'
      t.string :city, comment: '市'
      t.string :district, comment: '区/县'

      t.timestamps
    end
  end
end
