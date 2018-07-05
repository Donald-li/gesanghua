class AddColumnOperatorToAccountRecord < ActiveRecord::Migration[5.1]
  def change
    add_column :account_records, :operator_id, :integer, comment: '操作人id'
  end
end
