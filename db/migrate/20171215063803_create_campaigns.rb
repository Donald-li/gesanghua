class CreateCampaigns < ActiveRecord::Migration[5.1]
  def change
    create_table :campaigns, comment: '活动表' do |t|
      t.string :name, comment: '名称'
      t.decimal :price, precision: 14, scale: 2, default: "0.0", comment: '报名费'
      t.text :content, comment: '内容'
      t.datetime :start_time, comment: '预计开始时间'
      t.datetime :end_time, comment: '预计结束时间'
      t.datetime :sign_up_end_time, comment: '报名截止时间'
      t.datetime :start_at, comment: '活动开始时间'
      t.datetime :end_at, comment: '活动结束时间'
      t.integer :state, comment: '状态，1：展示 2：隐藏'
      t.integer :project_id, comment: '关联项目ID'
      t.integer :campaign_category_id, comment: '活动分类ID'

      t.timestamps
    end
  end
end
