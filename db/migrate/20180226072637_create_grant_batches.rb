class CreateGrantBatches < ActiveRecord::Migration[5.1]
  def change
    create_table :grant_batches, comment: '发放批次' do |t|
      t.integer :project_id, comment: '所属项目'
      t.string :batch_no, comment: '批次号'
      t.string :name, comment: '名称'
      t.text :description, comment: '描述'
      t.integer :state, comment: '状态'
      t.integer :user_id, comment: '发放负责人'
      t.datetime :grant_at, comment: '发放时间'

      t.timestamps
    end

    add_column :grants, :grant_batch_id, :integer, comment: '批次号'
  end
end
