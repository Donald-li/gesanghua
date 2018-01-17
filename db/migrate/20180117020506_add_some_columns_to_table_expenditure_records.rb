class AddSomeColumnsToTableExpenditureRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :expenditure_records, :name, :string, comment: '支出名称'
    add_column :expenditure_records, :expend_no, :string, comment: '支出编号'
    add_column :expenditure_records, :expended_at, :datetime, comment: '支出时间'
    add_column :expenditure_records, :operator, :string, comment: '支出经办人'
    add_column :expenditure_records, :remark, :text, comment: '备注'
    add_column :expenditure_records, :amount, :decimal, precision: 14, scale: 2, default: "0.0", comment: '支出金额'
    add_column :expenditure_records, :fund_category_id, :integer, comment: '财务分类ID'
  end
end
