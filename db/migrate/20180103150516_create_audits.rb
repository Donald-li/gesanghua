class CreateAudits < ActiveRecord::Migration[5.1]
  def change
    create_table :audits do |t|
      t.references :owner, polymorphic: true, index: true
      t.integer :state, comment: '审核状态 0:待审核 1:通过 2:未通过'
      t.integer :user_id, comment: '审核人'
      t.text :comment, comment: '评语'

      t.timestamps
    end
  end
end
