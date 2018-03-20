class CreateBadgeLevels < ActiveRecord::Migration[5.1]
  def change
    create_table :badge_levels, comment: '勋章级别' do |t|
      t.integer :kind, comment: '类型'
      t.string :title, comment: '标题'
      t.integer :position, comment: '排序'
      t.integer :value, comment: '获得条件'
      t.string :rank, comment: '级别描述'

      t.timestamps
    end
  end
end
