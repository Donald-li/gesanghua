class AddColumnRemarkToTableIncomeRecord < ActiveRecord::Migration[5.1]
  def change
    add_column :income_records, :remark, :text, comment: '备注'
  end
end
