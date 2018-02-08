class CreateDonations < ActiveRecord::Migration[5.1]
  def change
    create_table :donations, comment: '可捐助项目表' do |t|
      t.string :name, comment: '名称'
      t.string :describe, comment: '说明'
      t.integer :state, comment: '状态： 1：显示 2：隐藏'
      t.integer :position, comment: '排序'
      t.integer :fund_id, comment: '基金id'

      t.timestamps
    end
  end
end
