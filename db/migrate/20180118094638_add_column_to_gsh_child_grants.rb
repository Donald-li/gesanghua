class AddColumnToGshChildGrants < ActiveRecord::Migration[5.1]
  def change
    add_column :gsh_child_grants, :operator_id, :integer, comment: '异常处理人id'
  end
end
