class AddKindToTableVouchers < ActiveRecord::Migration[5.1]
  def change
    add_column :vouchers, :kind, :integer, comment: '开票类型'
    add_column :vouchers, :tax_no, :string, comment: '开票税号'
    add_column :vouchers, :voucher_no, :string, comment: '发票编号'
    add_column :vouchers, :tax_company, :string, comment: '开票单位'
    add_column :donate_records, :voucher_id, :integer, comment: '捐助记录ID'
  end
end
