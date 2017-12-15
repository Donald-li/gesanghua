class CreateLogistics < ActiveRecord::Migration[5.1]
  def change
    create_table :logistics, comment: '物流表' do |t|
      t.integer :name, comment: '物流公司 1:顺丰'
      t.string :number, comment: '物流单号'
      t.string :owner_type
      t.integer :owner_id

      t.timestamps
    end
  end
end
