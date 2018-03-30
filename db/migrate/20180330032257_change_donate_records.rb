class ChangeDonateRecords < ActiveRecord::Migration[5.1]
  def change
    change_table :donate_records do |t|
      t.remove :kind, :pay_state, :pay_result, :certificate_no, :donate_no, :donor, :remitter_name, :voucher_state, :voucher_id, :message, :period, :month_donate_id, :bookshelf_supplement_id, :appoint_type, :appoint_id
      t.references :source, polymorphic: true, index: true, comment: '资金来源'
      t.references :owner, polymorphic: true, index: true, comment: '捐助所属捐助项'
      t.rename :user_id, :donor_id #, comment: '捐助人id，有可能是线下捐助者'
      t.rename :remitter_id, :agent_id #, comment: '代理人id，实际付款的人'
      t.integer :donation_id, comment: '捐助id'
      t.integer :kind, comment: '捐助方式 1:捐款 2:配捐'

    end
  end
end
