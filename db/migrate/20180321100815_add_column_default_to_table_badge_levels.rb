class AddColumnDefaultToTableBadgeLevels < ActiveRecord::Migration[5.1]
  def change
    add_column :badge_levels, :default_level, :boolean, default: false, comment: '默认徽章'
  end
end
