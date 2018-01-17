class AddSomeColumnToSomeTable < ActiveRecord::Migration[5.1]
  def change
    add_column :income_records, :income_time, :datetime, comment: '入账时间'
    add_column :income_sources, :kind, :integer, comment: '类型： 1:线上（online） 2:线下（offline）'
    add_column :users, :donate_count, :decimal, precision: 14, scale: 2, default: "0", comment: '捐助金额'
    add_column :users, :online_count, :decimal, precision: 14, scale: 2, default: "0", comment: '线上捐助金额'
    add_column :users, :offline_count, :decimal, precision: 14, scale: 2, default: "0", comment: '线下捐助金额'
  end
end
