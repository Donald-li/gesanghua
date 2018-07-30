class AddColumnMessageToDonationAndDonateRecordAndGshChildGrants < ActiveRecord::Migration[5.1]
  def change
    add_column :donations, :message, :text, comment: '留言'
    add_column :donate_records, :message, :text, comment: '留言'
    add_column :gsh_child_grants, :message, :text, comment: '留言'
  end
end
