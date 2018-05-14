class AddColumnDescriptionToTableBadgeLevels < ActiveRecord::Migration[5.1]
  def change
    add_column :badge_levels, :description, :string, after: :rank, comment: '徽章描述'
    add_column :volunteers, :volunteer_age, :integer, comment: '服务年限'
  end
end
