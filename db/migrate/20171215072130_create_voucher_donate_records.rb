class CreateVoucherDonateRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :voucher_donate_records, comment: '捐赠收据记录表' do |t|
      t.integer :voucher_id, comment: '捐赠收据ID'
      t.integer :donate_record_id, comment: '捐赠记录ID'

      t.timestamps
    end
  end
end
