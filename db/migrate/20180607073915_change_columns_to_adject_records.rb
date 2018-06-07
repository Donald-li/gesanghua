class ChangeColumnsToAdjectRecords < ActiveRecord::Migration[5.1]
  def change
    remove_column :adjust_records, :from_fund_id, :integer
    remove_column :adjust_records, :to_fund_id, :integer
    add_column :adjust_records, :from_item_id, :integer
    add_column :adjust_records, :from_item_type, :string
    add_column :adjust_records, :to_item_type, :string
    add_column :adjust_records, :to_item_id, :integer
  end
end
