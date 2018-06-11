class AddPulishedAtToSpecials < ActiveRecord::Migration[5.1]
  def change
    add_column :specials, :published_at, :datetime, comment: '发布时间'
  end
end
