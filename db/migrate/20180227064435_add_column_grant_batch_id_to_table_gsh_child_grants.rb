class AddColumnGrantBatchIdToTableGshChildGrants < ActiveRecord::Migration[5.1]
  def change
    add_column :gsh_child_grants, :grant_batch_id, :integer, comment: '发放批次'
  end
end
