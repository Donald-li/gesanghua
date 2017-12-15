class CreateChildTrails < ActiveRecord::Migration[5.1]
  def change
    create_table :child_trails, comment: '孩子轨迹表' do |t|
      t.integer :kind, comment: '分类，1：奖项 2：毕业 3：工作'
      t.text :content, comment: '详情'
      t.string :awarding_body, comment: '操作单位'
      t.datetime :awarding_at, comment: '操作时间'
      t.integer :child_id, comment: '孩子ID'

      t.timestamps
    end
  end
end
