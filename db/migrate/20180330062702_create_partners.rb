class CreatePartners < ActiveRecord::Migration[5.1]
  def change
    create_table :partners, comment: '合作伙伴' do |t|
      t.string :name, comment: '名称'
      t.string :url, comment: '链接'
      t.integer :position, comment: '排序'
      t.integer :state, comment: '状态： 1:显示 2:隐藏'
      t.timestamps
    end
  end
end
