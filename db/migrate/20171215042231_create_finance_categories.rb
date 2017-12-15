class CreateFinanceCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :finance_categories, comment: '财务分类表' do |t|
      t.string :name, comment: '分类名称'
      t.integer :position, comment: '排序'
      t.string :fund_name, comment: '基金名称'
      t.decimal :amount, precision: 14, scale: 2, default: "0.0", comment: '金额'
      t.string :describe, comment: '简介'
      t.string :ancestry

      t.timestamps
    end
  end
end
