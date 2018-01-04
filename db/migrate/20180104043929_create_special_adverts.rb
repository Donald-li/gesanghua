class CreateSpecialAdverts < ActiveRecord::Migration[5.1]
  def change
    create_table :special_adverts do |t|
      t.integer :special_id, comment: '专题id'
      t.integer :advert_id, comment: '广告id'
      t.integer :position, comment: '排序'

      t.timestamps
    end
  end
end
