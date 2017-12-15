class CreateCampaignCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :campaign_categories, comment: '活动分类表' do |t|
      t.string :name, comment: '名称'

      t.timestamps
    end
  end
end
