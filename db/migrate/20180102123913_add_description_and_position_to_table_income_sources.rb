class AddDescriptionAndPositionToTableIncomeSources < ActiveRecord::Migration[5.1]
  def change
    add_column :income_sources, :description, :string, comment: '描述'
    add_column :income_sources, :position, :integer, comment: '位置'
  end
end
