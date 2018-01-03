class AddKindToFundCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :fund_categories, :kind, :integer, default: 1, comment: '类型 1:非定向 2:定向'
    add_column :funds, :kind, :integer, default: 1, comment: '类型 1:非定向 2:定向'
    add_column :funds, :use_kind, :integer, default: 1, comment: '指定类型 1:非指定 2:指定'
  end
end
