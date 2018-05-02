class AddIncomeNoToIncomeRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :income_records, :income_no, :string, comment: '收入编号'
  end
end
