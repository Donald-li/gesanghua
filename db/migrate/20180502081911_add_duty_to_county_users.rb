class AddDutyToCountyUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :county_users, :duty, :string, comment: '职务'
  end
end
