class AddDisplayPositionToSupports < ActiveRecord::Migration[5.1]
  def change
    remove_column :supports, :alias, :string
    add_column :supports, :display_position, :integer, comment: '显示位置'
  end
end
