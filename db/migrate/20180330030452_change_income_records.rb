class ChangeIncomeRecords < ActiveRecord::Migration[5.1]
  def change
    change_table :income_records do |t|
      t.remove :appoint_type, :appoint_id, :donor, :remitter_name, :state
      t.integer :donation_id, comment: '捐助id'
      t.rename :user_id, :donor_id #, comment: '捐助人id，有可能是线下捐助者'
      t.rename :remitter_id, :agent_id #, comment: '代理人id，实际付款的人'
      t.integer :kind, comment: '来源: 1:线上 2:线下'
    end
  end
end
