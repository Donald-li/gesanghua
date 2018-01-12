class CreateGrants < ActiveRecord::Migration[5.1]
  def change
    create_table :grants, comment: '发放表' do |t|
      t.integer :project_id, comment: '归属项目ID'
      t.integer :project_season_id, comment: '项目年度ID'
      t.integer :school_id, comment: '学校ID'
      t.integer :project_season_apply_id, comment: '项目申请ID'
      t.integer :gsh_child_id, comment: '格桑花孩子ID'
      t.string :grant_no, comment: '发放编号'
      t.integer :state, comment: '状态'
      t.decimal :amount, precision: 14, scale: 2, default: "0.0", comment: "资助金额"

      t.timestamps
    end
  end
end
