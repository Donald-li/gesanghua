class AddTitleToDonateRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :donate_records, :title, :string, comment: '捐赠标题'
    add_column :donate_records, :pay_result, :string, comment: '支付结果'
  end
end
