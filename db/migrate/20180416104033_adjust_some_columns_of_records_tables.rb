class AdjustSomeColumnsOfRecordsTables < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :online_count, :online_amount
    rename_column :users, :offline_count, :offline_amount
    rename_column :users, :donate_count, :donate_amount

    remove_column :donations, :voucher_state, :integer
    remove_column :donations, :voucher_id, :integer
    remove_column :donations, :certificate_no, :string

    add_column :income_records, :certificate_no, :string, comment: '捐赠证书编号'

  end
end
