class AddApplyChildToTableVisits < ActiveRecord::Migration[5.1]
  def change
    add_column :visits, :apply_child_id, :integer, comment: '孩子申请ID'
  end
end
