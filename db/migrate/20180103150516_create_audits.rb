class CreateAudits < ActiveRecord::Migration[5.1]
  def change
    create_table :audits do |t|
      t.references :owner, polymorphic: true, index: true
      # t.string :owner_type, comment: '多态类型'
      # t.integer :owner_id, comment: '多态id'
      t.integer :user_id, comment: '审核人'
      t.text :comment, comment: '评语'

      t.timestamps
    end
  end
end
