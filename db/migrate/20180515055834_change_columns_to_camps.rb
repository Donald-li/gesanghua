class ChangeColumnsToCamps < ActiveRecord::Migration[5.1]
  def change
    remove_column :camps, :manager_id, :integer
    add_column :camps, :manager, :string, comment: '负责人'
  end
end
