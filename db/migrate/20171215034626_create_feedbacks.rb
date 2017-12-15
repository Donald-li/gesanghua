class CreateFeedbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :feedbacks, comment: '反馈表' do |t|
      t.text :content, comment: '内容'
      t.string :owner_type, comment: ''
      t.integer :owner_id, comment: ''
      t.integer :type, comment: '类型：receive、install、continual'
      t.integer :state, comment: '状态'
      t.integer :approve_state, comment: '审核状态'

      t.timestamps
    end
  end
end