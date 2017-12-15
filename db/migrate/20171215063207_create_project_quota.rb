class CreateProjectQuota < ActiveRecord::Migration[5.1]
  def change
    create_table :project_quota, comment: '项目配额' do |t|
      t.integer :school_id, comment: '学校ID'
      t.integer :project_id, comment: '项目ID'
      t.decimal :amount, precision: 14, scale: 2, default: "0.0", comment: '金额'
      t.string :province, comment: '省'
      t.string :city, comment: '市'
      t.string :district, comment: '区/县'

      t.timestamps
    end
  end
end
