class CreateCompDocumentSummaries < ActiveRecord::Migration[5.1]
  def change
    create_table :comp_document_summaries, comment: '拓展营总结' do |t|
      t.integer :project_id, comment: '项目'
      t.integer :user_id, comment: '用户'
      t.datetime :submit_at, comment: '提交时间'
      t.string :submit_user, comment: '提交用户'
      t.string :free_resource, comment: '本营免费资源'
      t.decimal :resource_value, precision: 14, scale: 2, default:  0.0, comment: '免费资源价值'
      t.decimal :donate_amount, precision: 14, scale: 2, default:  0.0, comment: '本营筹款多少'
      t.integer :publicize_count, comment: '本营宣传次数'

      t.timestamps
    end
  end
end
