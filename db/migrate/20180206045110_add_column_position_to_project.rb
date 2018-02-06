class AddColumnPositionToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :position, :integer, comment: '位置排序'
  end
end
