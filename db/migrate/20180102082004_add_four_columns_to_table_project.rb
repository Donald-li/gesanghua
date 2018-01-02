class AddFourColumnsToTableProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :junior_term_amount, :decimal, precision: 14, scale: 2, default: "0.0", comment: '初中资助金额（学期）'
    add_column :projects, :junior_year_amount, :decimal, precision: 14, scale: 2, default: "0.0", comment: '初中资助金额（学年）'
    add_column :projects, :senior_term_amount, :decimal, precision: 14, scale: 2, default: "0.0", comment: '高中资助金额（学期）'
    add_column :projects, :senior_year_amount, :decimal, precision: 14, scale: 2, default: "0.0", comment: '高中资助金额（学年）'
  end
end
